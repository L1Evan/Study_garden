class Plant {
  final String id;
  final String name;
  final String type;
  final int growthStage;
  final int minutesAccumulated;
  final bool isActive;
  final String createdAt;

  Plant({
    required this.id,
    required this.name,
    required this.type,
    required this.growthStage,
    required this.minutesAccumulated,
    required this.isActive,
    required this.createdAt,
  });

  Plant copyWith({
    String? id,
    String? name,
    String? type,
    int? growthStage,
    int? minutesAccumulated,
    bool? isActive,
    String? createdAt,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      growthStage: growthStage ?? this.growthStage,
      minutesAccumulated: minutesAccumulated ?? this.minutesAccumulated,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'growth_stage': growthStage,
      'minutes_accumulated': minutesAccumulated,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      growthStage: map['growth_stage'] as int,
      minutesAccumulated: map['minutes_accumulated'] as int,
      isActive: (map['is_active'] as int) == 1,
      createdAt: map['created_at'] as String,
    );
  }
}
