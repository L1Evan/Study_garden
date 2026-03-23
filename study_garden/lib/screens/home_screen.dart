import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/garden_provider.dart';
import 'models/plant.dart';
import 'plant_detail_screen.dart';
import 'focus_screen.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Garden'),
        // Sunlight counter in actions
        actions: [
          Consumer<GardenProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.sunlight}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<GardenProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final plants = provider.plants;

          return Column(
            children: [
              // Smart suggestion banner at top
              if (provider.sessions.isNotEmpty)
                _SuggestionBanner(provider: provider),
              
              // Main grid
              Expanded(
                child: plants.isEmpty 
                  ? _EmptyState(onAdd: () => _showAddPlantDialog(context))
                  : _PlantGrid(
                      plants: plants,
                      onPlantTap: (plant) => _showPlantOptions(context, plant),
                      onAddTap: () => _showAddPlantDialog(context),
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPlantOptions(BuildContext context, Plant plant) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow, color: Colors.green),
              title: const Text('Start Focus Session'),
              subtitle: Text('Grow ${plant.name}'),
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FocusScreen(plant: plant),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlantDetailScreen(plant: plant),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPlantDialog(BuildContext context) {
    final nameController = TextEditingController();
    String selectedType = 'Succulent';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Plant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Plant Name',
                hintText: 'e.g., Math Succulent',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(labelText: 'Type'),
              items: ['Succulent', 'Flower', 'Cactus', 'Tree', 'Herb']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) => selectedType = value!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<GardenProvider>().addPlant(
                      name: nameController.text,
                      type: selectedType,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Plant'),
          ),
        ],
      ),
    );
  }
}

// Extracted widgets for cleaner code

class _SuggestionBanner extends StatelessWidget {
  final GardenProvider provider;

  const _SuggestionBanner({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: Colors.green.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              provider.getSmartSuggestion(),
              style: TextStyle(color: Colors.green.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_florist, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Your garden is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Plant Your First Seed'),
          ),
        ],
      ),
    );
  }
}

class _PlantGrid extends StatelessWidget {
  final List<Plant> plants;
  final Function(Plant) onPlantTap;
  final VoidCallback onAddTap;

  const _PlantGrid({
    required this.plants,
    required this.onPlantTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: plants.length + 1, // +1 for add button
      itemBuilder: (context, index) {
        if (index == plants.length) {
          return _AddPlantCard(onTap: onAddTap);
        }
        
        final plant = plants[index];
        return _PlantCard(plant: plant, onTap: () => onPlantTap(plant));
      },
    );
  }
}

class _PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;

  const _PlantCard({required this.plant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Visual growth representation
    String emoji = '🌱';
    Color color = Colors.green.shade100;
    if (plant.growthStage >= 5) {
      emoji = '🌻';
      color = Colors.yellow.shade100;
    } else if (plant.growthStage >= 3) {
      emoji = '🌿';
      color = Colors.lightGreen.shade100;
    } else if (plant.growthStage >= 2) {
      emoji = '🪴';
    }

    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              plant.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Stage ${plant.growthStage}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            ),
            Text(
              '${plant.minutesAccumulated} min total',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddPlantCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPlantCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('New Plant', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}