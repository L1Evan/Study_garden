import 'package:flutter/material.dart';
import '../models/plant.dart';

/// Displays a plant in the garden grid
/// Shows growth stage visually with emoji and color
class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    this.onLongPress,
  });

  /// Determines visual representation based on growth
  ({String emoji, Color color, String stageLabel}) get _visuals {
    if (plant.growthStage >= 5) {
      return (
        emoji: '🌻',
        color: Colors.yellow.shade100,
        stageLabel: 'Blooming',
      );
    } else if (plant.growthStage >= 3) {
      return (
        emoji: '🌿',
        color: Colors.lightGreen.shade100,
        stageLabel: 'Growing',
      );
    } else if (plant.growthStage >= 2) {
      return (
        emoji: '🪴',
        color: Colors.green.shade50,
        stageLabel: 'Sprout',
      );
    } else {
      return (
        emoji: '🌱',
        color: Colors.green.shade50,
        stageLabel: 'Seedling',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visuals = _visuals;

    return Card(
      color: visuals.color,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated size based on growth
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Text(
                      visuals.emoji,
                      style: const TextStyle(fontSize: 48),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                plant.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  visuals.stageLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${plant.minutesAccumulated} min',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}