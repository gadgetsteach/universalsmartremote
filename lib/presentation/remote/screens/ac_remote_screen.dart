import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/ir_device.dart';
import '../../home/providers/ir_provider.dart';
import '../providers/remote_provider.dart';

class AcRemoteScreen extends ConsumerStatefulWidget {
  final int deviceId;

  const AcRemoteScreen({super.key, required this.deviceId});

  @override
  ConsumerState<AcRemoteScreen> createState() => _AcRemoteScreenState();
}

class _AcRemoteScreenState extends ConsumerState<AcRemoteScreen> {
  int _currentTemp = 24;
  String _currentMode = 'Cool';

  void _sendCommand(IrDevice device, String command) async {
    final pattern = device.buttons[command];
    if (pattern != null) {
      final repo = ref.read(irRepositoryProvider);
      final hasEmitter = await repo.hasIrEmitter();
      if (!hasEmitter) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Simulated sending $command command (No IR Emitter)')),
        );
        return;
      }
      await repo.transmit(device.carrierFrequency, pattern);
    }
  }

  void _changeTemp(IrDevice device, int delta) {
    setState(() {
      _currentTemp = (_currentTemp + delta).clamp(16, 30);
    });
    _sendCommand(device, delta > 0 ? 'temp_up' : 'temp_down');
  }
  
  void _setMode(IrDevice device, String mode) {
    setState(() {
      _currentMode = mode;
    });
    // In a real scenario, you'd send a specific mode command. We map it to 'mode' for now.
    _sendCommand(device, 'mode');
  }

  @override
  Widget build(BuildContext context) {
    final deviceAsync = ref.watch(deviceByIdProvider(widget.deviceId));

    return Scaffold(
      appBar: AppBar(
        title: deviceAsync.when(
          data: (device) => Text(device?.brand ?? 'AC Remote'),
          loading: () => const Text('Loading...'),
          error: (_, _) => const Text('Error'),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu actions
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(value: 'rename', child: Text('Rename')),
                const PopupMenuItem(value: 'pair', child: Text('Pair again')),
                const PopupMenuItem(value: 'add_home', child: Text('Add to Home screen')),
                const PopupMenuItem(value: 'share', child: Text('Share')),
                const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
              ];
            },
          ),
        ],
      ),
      body: deviceAsync.when(
        data: (device) {
          if (device == null) {
            return const Center(child: Text('Device not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: [
                // Display
                Text(
                  '$_currentTemp',
                  style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(_currentMode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('Mode', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(width: 48),
                    const Column(
                      children: [
                        Text('Auto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Fan speed', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Power and Swing
                Row(
                  children: [
                    Expanded(
                      child: _buildPillButton(
                        context,
                        Icons.power_settings_new,
                        'Power',
                        iconColor: Colors.red,
                        onTap: () => _sendCommand(device, 'power'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPillButton(
                        context,
                        Icons.compare_arrows,
                        'Swing',
                        onTap: () => _sendCommand(device, 'swing'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Temperature Pill
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        padding: const EdgeInsets.all(24),
                        onPressed: () => _changeTemp(device, -1),
                      ),
                      const Expanded(
                        child: Text(
                          'Temperature',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        padding: const EdgeInsets.all(24),
                        onPressed: () => _changeTemp(device, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Modes Container
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildModeButton(context, device, 'Auto', Icons.font_download_outlined, false),
                      _buildModeButton(context, device, 'Cool', Icons.ac_unit, _currentMode == 'Cool'),
                      _buildModeButton(context, device, 'Heating', Icons.wb_sunny_outlined, _currentMode == 'Heating'),
                      _buildModeButton(context, device, 'Dry', Icons.water_drop_outlined, _currentMode == 'Dry'),
                      _buildModeButton(context, device, 'Fan', Icons.cyclone, _currentMode == 'Fan'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Extra Controls Container
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildModeButton(context, device, 'Sleep', Icons.nights_stay_outlined, false),
                      _buildModeButton(context, device, 'Timer', Icons.access_time, false),
                      _buildModeButton(context, device, 'Direction', Icons.swap_vert, false),
                      _buildModeButton(context, device, 'Fan speed', Icons.speed, false),
                      _buildModeButton(context, device, 'More', Icons.grid_view, false),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildPillButton(BuildContext context, IconData icon, String text, {Color? iconColor, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(BuildContext context, IrDevice device, String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (['Auto', 'Cool', 'Heating', 'Dry', 'Fan'].contains(label)) {
          _setMode(device, label);
        } else {
          _sendCommand(device, label.toLowerCase());
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent : Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isSelected ? Colors.white : Colors.grey.shade400),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
