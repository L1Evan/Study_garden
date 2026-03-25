class FocusSession {
  final String id;
  final String plantId;
  final int durationMinutes;
  final int sunlightEarned;
  final bool completed;
  final String startedAt;
  final String? endedAt;
  final String notes;

  FocusSession({
    required this.id,
    required this.plantId,
    required this.durationMinutes,
    required this.sunlightEarned,
    required this.completed,
    required this.startedAt,
    required this.endedAt,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plant_id': plantId,
      'duration_minutes': durationMinutes,
      'sunlight_earned': sunlightEarned,
      'completed': completed ? 1 : 0,
      'started_at': startedAt,
      'ended_at': endedAt,
      'notes': notes,
    };
  }

  factory FocusSession.fromMap(Map<String, dynamic> map) {
    return FocusSession(
      id: map['id'] as String,
      plantId: map['plant_id'] as String,
      durationMinutes: map['duration_minutes'] as int,
      sunlightEarned: map['sunlight_earned'] as int,
      completed: (map['completed'] as int) == 1,
      startedAt: map['started_at'] as String,
      endedAt: map['ended_at'] as String?,
      notes: (map['notes'] ?? '') as String,
    );
  }
}
