import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/plant.dart';
import '../providers/garden_provider.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailScreen({
    super.key,
    required this.plant,
  });

  Future<void> _renamePlant(BuildContext context) async {
    final controller = TextEditingController(text: plant.name);
    final formKey = GlobalKey<FormState>();
    final gardenProvider = context.read<GardenProvider>();
    final navigator = Navigator.of(context);

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rename Plant'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Plant Name'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Plant name cannot be empty';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await gardenProvider.renamePlant(
                  plant.id,
                  controller.text.trim(),
                );
                navigator.pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _archivePlant(BuildContext context) async {
    final gardenProvider = context.read<GardenProvider>();
    final navigator = Navigator.of(context);

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Archive Plant'),
            content: const Text('This plant will be removed from the active garden.'),
            actions: [
              TextButton(
                onPressed: () => navigator.pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => navigator.pop(true),
                child: const Text('Archive'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      await gardenProvider.archivePlant(plant.id);
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GardenProvider>();
    final matchingPlants = provider.plants.where((p) => p.id == plant.id).toList();
    final displayPlant = matchingPlants.isNotEmpty ? matchingPlants.first : plant;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('🪴', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 12),
                    Text(
                      displayPlant.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Type: ${displayPlant.type}'),
                    Text('Growth Stage: ${displayPlant.growthStage}'),
                    Text('Total Focus Time: ${displayPlant.minutesAccumulated} minutes'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _renamePlant(context),
              icon: const Icon(Icons.edit),
              label: const Text('Rename Plant'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _archivePlant(context),
              icon: const Icon(Icons.archive),
              label: const Text('Archive Plant'),
            ),
          ],
        ),
      ),
    );
  }
}