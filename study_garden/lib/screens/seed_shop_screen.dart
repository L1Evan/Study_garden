import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/garden_provider.dart';
import 'models/shop_item.dart';

class SeedShop extends StatelessWidget {
  const SeedShop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seed Shop'),
        // Show current sunlight
        actions: [
          Consumer<GardenProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${provider.sunlight}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<GardenProvider>(
        builder: (context, provider, child) {
          final items = provider.shopItems;
          
          if (items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _ShopItemCard(
                item: item,
                sunlight: provider.sunlight,
                onBuy: () => _purchaseItem(context, item),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _purchaseItem(BuildContext context, ShopItem item) async {
    final provider = context.read<GardenProvider>();
    
    try {
      await provider.buyShopItem(item.id);
      
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unlocked ${item.name}!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough sunlight ☀️ Keep studying!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}

class _ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final int sunlight;
  final VoidCallback onBuy;

  const _ShopItemCard({
    required this.item,
    required this.sunlight,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = sunlight >= item.price;
    final icon = item.category == 'Seed' 
        ? Icons.local_florist 
        : Icons.inventory_2;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: item.isUnlocked 
              ? Colors.green.shade100 
              : Colors.grey.shade200,
          child: Icon(
            icon,
            color: item.isUnlocked ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(item.name),
        subtitle: Text(item.category),
        trailing: item.isUnlocked
            ? Chip(
                label: const Text('Owned'),
                backgroundColor: Colors.green.shade100,
                side: BorderSide.none,
              )
            : FilledButton(
                onPressed: canAfford ? onBuy : null,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wb_sunny, size: 16),
                    const SizedBox(width: 4),
                    Text('${item.price}'),
                  ],
                ),
              ),
      ),
    );
  }
}