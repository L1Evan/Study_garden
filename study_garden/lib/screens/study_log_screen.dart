import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/garden_provider.dart';
import '../widgets/stat_card.dart';        // widget
import '../widgets/empty_state.dart';      // widget
import '../models/focus_session.dart';

class StudyLog extends StatelessWidget {
  const StudyLog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Log')),
      body: Consumer<GardenProvider>(
        builder: (context, provider, child) {
          final sessions = provider.sessions;
          final todayMinutes = provider.getTodayMinutes();

          if (sessions.isEmpty) {
            return EmptyState(              //  widget
              icon: Icons.bar_chart,
              title: 'No sessions yet',
              subtitle: 'Complete a focus session to see your progress',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Stats header using the widget
              StatCard(                     // widget
                icon: Icons.today,
                value: '$todayMinutes',
                label: 'Minutes Today',
                color: Colors.green,
                large: true,
              ),
              const SizedBox(height: 16),
              
              // Session count
              StatCard(                     //  widget
                icon: Icons.format_list_numbered,
                value: '${sessions.length}',
                label: 'Total Sessions',
                color: Colors.blue,
                large: true,
              ),
              const SizedBox(height: 24),
              
              // Recent sessions list
              Text(
                'Recent Sessions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              
              ...sessions.map((s) => _SessionTile(session: s)),
            ],
          );
        },
      ),
    );
  }
}