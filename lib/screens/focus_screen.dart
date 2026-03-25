import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../providers/garden_provider.dart';
import '../services/settings_service.dart';

class FocusScreen extends StatefulWidget {
  final Plant plant;

  const FocusScreen({super.key, required this.plant});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  Timer? _timer;
  late int _secondsRemaining;
  late int _initialSeconds;
  bool _isRunning = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadDefaultDuration();
  }

  Future<void> _loadDefaultDuration() async {
    final settings = SettingsService();
    await settings.init();
    final minutes = settings.getDefaultSessionDuration();
    
    setState(() {
      _initialSeconds = minutes * 60;
      _secondsRemaining = minutes * 60;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _completeSession();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _completeSession() {
    _timer?.cancel();

    final secondsCompleted = _initialSeconds - _secondsRemaining;

    // Award at least one minute after 30 seconds of work
    final minutesCompleted = ((secondsCompleted + 30) / 60).floor();

    if (minutesCompleted > 0) {
      context.read<GardenProvider>().completeFocusSession(
        plantId: widget.plant.id,
        durationMinutes: minutesCompleted,
      );
    }

    setState(() {
      _isRunning = false;
      _isCompleted = true;
    });
  }

  String get _timeDisplay {
    final m = _secondsRemaining ~/ 60;
    final s = _secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _progress {
    if (_initialSeconds == 0) return 0;
    return (_initialSeconds - _secondsRemaining) / _initialSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.plant.name),
        actions: [
          // Time adjustment (only when not running)
          if (!_isRunning && !_isCompleted)
            IconButton(
              icon: const Icon(Icons.timer),
              onPressed: _adjustDuration,
            ),
        ],
      ),
      body: SafeArea(
        child: _isCompleted
            ? _buildCompletedState()
            : Column(
                children: [
                  const Spacer(),
                  
                  // Plant visualization
                  Text(
                    _getPlantEmoji(),
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              _isCompleted ? 'Growth Complete!' : 'Growing...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            
            // Timer ring
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 12,
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(
                  width: 250,
                  height: 250,
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: _progress),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return CircularProgressIndicator(
                        value: value,
                        strokeWidth: 12,
                        color: Colors.green,
                        strokeCap: StrokeCap.round,
                      );
                    },
                  ),
                ),
                Text(
                  _timeDisplay,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Controls
            if (_isCompleted)
              _buildCompletedState()
            else
              _buildControls(),
              
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  String _getPlantEmoji() {
    if (_isCompleted) return '🌻';
    if (_progress > 0.7) return '🌿';
    if (_progress > 0.3) return '🌱';
    return '🪴';
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isRunning) ...[
          FloatingActionButton.large(
            onPressed: _pauseTimer,
            backgroundColor: Colors.orange,
            heroTag: 'pause', // Prevents hero animation conflicts
            child: const Icon(Icons.pause, size: 32),
          ),
          const SizedBox(width: 24),
          FloatingActionButton(
            onPressed: _completeSession,
            backgroundColor: Colors.red.shade300,
            heroTag: 'stop',
            child: const Icon(Icons.stop),
          ),
        ] else ...[
          FloatingActionButton.large(
            onPressed: _startTimer,
            backgroundColor: Colors.green,
            heroTag: 'start',
            child: const Icon(Icons.play_arrow, size: 32),
          ),
          if (_secondsRemaining < _initialSeconds) ...[
            const SizedBox(width: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildCompletedState() {
    final minutes = (_initialSeconds - _secondsRemaining) ~/ 60;
    final sunlightEarned = (minutes + (minutes ~/ 15) * 5);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _getPlantEmoji(),
            style: const TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 12),
          Text(
            'Growth Complete!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 18),
          Text(
            '+$minutes minutes added!',
            style: const TextStyle(fontSize: 20, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Text(
            '☀️ +$sunlightEarned sunlight',
            style: const TextStyle(fontSize: 18, color: Colors.lightGreen),
          ),
          const SizedBox(height: 16),
          const Text(
            'Great job! Keep going.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check),
            label: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _adjustDuration() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('Select Duration'),
              leading: Icon(Icons.timer),
            ),
            const Divider(),
            ...[1, 5, 10, 15, 20, 25, 30, 45, 60].map((minutes) {
              return ListTile(
                title: Text('$minutes minutes'),
                trailing: _initialSeconds == minutes * 60
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  setState(() {
                    _initialSeconds = minutes * 60;
                    _secondsRemaining = minutes * 60;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}