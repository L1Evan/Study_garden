import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/focus_session.dart';
import '../models/plant.dart';
import '../models/shop_item.dart';
import '../services/database_helper.dart';

class GardenProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  List<Plant> _plants = <Plant>[];
  List<FocusSession> _sessions = <FocusSession>[];
  List<ShopItem> _shopItems = <ShopItem>[];
  int _sunlight = 0;
  bool _isLoading = false;

  List<Plant> get plants => _plants.where((Plant p) => p.isActive).toList();
  List<FocusSession> get sessions => _sessions;
  List<ShopItem> get shopItems => _shopItems;
  int get sunlight => _sunlight;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    await _loadAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadAll() async {
    final db = await _dbHelper.database;

    final plantMaps = await db.query('plants', orderBy: 'created_at DESC');
    _plants = plantMaps
        .map((map) => Plant.fromMap(map))
        .toList();

    final sessionMaps = await db.query('focus_sessions', orderBy: 'started_at DESC');
    _sessions = sessionMaps
        .map((map) => FocusSession.fromMap(map))
        .toList();

    final shopMaps = await db.query('shop_items', orderBy: 'price ASC');
    _shopItems = shopMaps
        .map((map) => ShopItem.fromMap(map))
        .toList();

    final statMaps = await db.query('app_stats', where: 'id = ?', whereArgs: [1]);
    if (statMaps.isNotEmpty) {
      _sunlight = statMaps.first['sunlight'] as int;
    }
  }

  Future<void> addPlant({
    required String name,
    required String type,
  }) async {
    final db = await _dbHelper.database;

    final plant = Plant(
      id: _uuid.v4(),
      name: name,
      type: type,
      growthStage: 1,
      minutesAccumulated: 0,
      isActive: true,
      createdAt: DateTime.now().toIso8601String(),
    );

    await db.insert('plants', plant.toMap());
    _plants.insert(0, plant);
    notifyListeners();
  }

  Future<void> renamePlant(String id, String newName) async {
    final db = await _dbHelper.database;

    await db.update(
      'plants',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [id],
    );

    final index = _plants.indexWhere((p) => p.id == id);
    if (index != -1) {
      _plants[index] = _plants[index].copyWith(name: newName);
      notifyListeners();
    }
  }

  Future<void> archivePlant(String id) async {
    final db = await _dbHelper.database;

    await db.update(
      'plants',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );

    final index = _plants.indexWhere((p) => p.id == id);
    if (index != -1) {
      _plants[index] = _plants[index].copyWith(isActive: false);
      notifyListeners();
    }
  }

  Future<void> completeFocusSession({
    required String plantId,
    required int durationMinutes,
    String notes = '',
  }) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();

    // More sunlight reward: base plus time bonus
    final baseSunlight = durationMinutes;
    final bonus = (durationMinutes ~/ 15) * 5; // +5 per 15 minute block
    final sunlightEarned = baseSunlight + bonus;

    final session = FocusSession(
      id: _uuid.v4(),
      plantId: plantId,
      durationMinutes: durationMinutes,
      sunlightEarned: sunlightEarned,
      completed: true,
      startedAt: now.subtract(Duration(minutes: durationMinutes)).toIso8601String(),
      endedAt: now.toIso8601String(),
      notes: notes,
    );

    await db.insert('focus_sessions', session.toMap());

    final plantIndex = _plants.indexWhere((p) => p.id == plantId);
    if (plantIndex != -1) {
      final plant = _plants[plantIndex];
      final newMinutes = plant.minutesAccumulated + durationMinutes;
      final newStage = (newMinutes ~/ 60) + 1;

      await db.update(
        'plants',
        {
          'minutes_accumulated': newMinutes,
          'growth_stage': newStage,
        },
        where: 'id = ?',
        whereArgs: [plantId],
      );

      _plants[plantIndex] = plant.copyWith(
        minutesAccumulated: newMinutes,
        growthStage: newStage,
      );
    }

    _sunlight += sunlightEarned;

    await db.update(
      'app_stats',
      {'sunlight': _sunlight},
      where: 'id = ?',
      whereArgs: [1],
    );

    _sessions.insert(0, session);
    notifyListeners();
  }

  Future<void> deleteSession(String sessionId) async {
    final db = await _dbHelper.database;

    await db.delete(
      'focus_sessions',
      where: 'id = ?',
      whereArgs: [sessionId],
    );

    _sessions.removeWhere((s) => s.id == sessionId);
    notifyListeners();
  }

  Future<void> buyShopItem(String itemId) async {
    final db = await _dbHelper.database;
    final index = _shopItems.indexWhere((item) => item.id == itemId);

    if (index == -1) return;

    final item = _shopItems[index];
    if (item.isUnlocked) return;

    if (_sunlight < item.price) {
      throw Exception('Not enough sunlight.');
    }

    _sunlight -= item.price;

    await db.update(
      'app_stats',
      {'sunlight': _sunlight},
      where: 'id = ?',
      whereArgs: [1],
    );

    await db.update(
      'shop_items',
      {'is_unlocked': 1},
      where: 'id = ?',
      whereArgs: [itemId],
    );

    _shopItems[index] = item.copyWith(isUnlocked: true);
    notifyListeners();
  }

  String getSmartSuggestion() {
    if (_sessions.isEmpty) {
      return 'Start with a 15-minute session to grow your first plant.';
    }

    final recent = _sessions.take(3).toList();
    final total = recent.fold<int>(
      0,
      (sum, session) => sum + session.durationMinutes,
    );
    final avg = total ~/ recent.length;

    if (avg < 20) {
      return 'Based on your recent sessions, try a 15-minute focus block.';
    } else if (avg < 40) {
      return 'You are doing well. A 25-minute Pomodoro should fit your pattern.';
    } else {
      return 'You handle longer focus time well. Try a 45-minute deep session.';
    }
  }

  int getTodayMinutes() {
    final now = DateTime.now();

    return _sessions.where((session) {
      final date = DateTime.parse(session.startedAt);
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).fold<int>(
      0,
      (sum, session) => sum + session.durationMinutes,
    );
  }
}
