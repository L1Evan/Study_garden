import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/garden_provider.dart';
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No sessions yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Complete a focus session to see your progress',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Stats header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.today, color: Colors.white, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          '$todayMinutes',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Minutes Today',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.format_list_numbered, color: Colors.white, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          '${sessions.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Total Sessions',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Session list
              Text(
                'Recent Sessions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              
              ...sessions.map((session) => _SessionTile(session: session)),
            ],
          );
        },
      ),
    );
  }
}

// WIDGET CLASS (must be in same file)

class _SessionTile extends StatelessWidget {
  final FocusSession session;

  const _SessionTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(session.startedAt);
    final timeString = '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green.shade100,
        child: const Icon(Icons.timer, color: Colors.green),
      ),
      title: Text('${session.durationMinutes} minutes'),
      subtitle: Text('${date.month}/${date.day} at $timeString'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wb_sunny, size: 16, color: Colors.amber),
          const SizedBox(width: 4),
          Text('+${session.sunlightEarned}'),
        ],
      ),
    );
  }
}