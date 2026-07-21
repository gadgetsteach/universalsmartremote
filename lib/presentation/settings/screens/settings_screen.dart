import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _vibration = true;
  bool _sound = true;
  bool _onlineData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Button vibration'),
                  value: _vibration,
                  activeThumbColor: Theme.of(context).primaryColor,
                  onChanged: (val) => setState(() => _vibration = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Button sound'),
                  value: _sound,
                  activeThumbColor: Theme.of(context).primaryColor,
                  onChanged: (val) => setState(() => _sound = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Obtain remote control data online'),
                  subtitle: const Text('Access an online database of remote control models.'),
                  value: _onlineData,
                  activeThumbColor: Theme.of(context).primaryColor,
                  onChanged: (val) => setState(() => _onlineData = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  title: Text('Version'),
                  subtitle: Text('16.5.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('About'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
