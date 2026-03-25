import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/settings_service.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _settings = SettingsService();
  int _defaultDuration = 25;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _settings.init();
    setState(() {
      _defaultDuration = _settings.getDefaultSessionDuration();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Section: Appearance
          const _SectionHeader(title: 'Appearance'),
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: Text(settingsProvider.isDarkMode
                    ? 'Dark mode is enabled'
                    : 'Light mode is enabled'),
                value: settingsProvider.isDarkMode,
                onChanged: (value) {
                  settingsProvider.setDarkMode(value);
                },
              );
            },
          ),
          
          // Section: Focus
          const _SectionHeader(title: 'Focus Settings'),
          ListTile(
            title: const Text('Default Session Duration'),
            trailing: DropdownButton<int>(
              value: _defaultDuration,
              underline: const SizedBox(),
              items: [15, 25, 45, 60].map((minutes) {
                return DropdownMenuItem(
                  value: minutes,
                  child: Text('$minutes min'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _defaultDuration = value);
                  _settings.setDefaultSessionDuration(value);
                }
              },
            ),
          ),
          
          // Section: Data
          const _SectionHeader(title: 'Data'),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Clear All Data', style: TextStyle(color: Colors.red)),
            onTap: () => _showClearDataDialog(context),
          ),
          
          // Section: About
          const _SectionHeader(title: 'About'),
          const ListTile(
            title: Text('StudySprout'),
            subtitle: Text('Version 1.0.0'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text('This will delete all plants and sessions. Cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // You'd call a clear method on DatabaseHelper here
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}