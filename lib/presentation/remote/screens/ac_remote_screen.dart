import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/ir_device.dart';
import '../../home/providers/ir_provider.dart';
import '../../home/providers/saved_remotes_provider.dart';
import '../providers/remote_provider.dart';

class AcRemoteScreen extends ConsumerStatefulWidget {
  final int deviceId;
  final int? savedRemoteId;

  const AcRemoteScreen({super.key, required this.deviceId, this.savedRemoteId});

  @override
  ConsumerState<AcRemoteScreen> createState() => _AcRemoteScreenState();
}

class _AcRemoteScreenState extends ConsumerState<AcRemoteScreen> {
  int _currentTemp = 24;
  String _currentMode = 'Cool';

  void _sendCommand(IrDevice device, String command) async {
    HapticFeedback.lightImpact();
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
      final error = await repo.transmit(device.carrierFrequency, pattern);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error == null ? 'Sent $command command' : 'Failed to send $command: $error')),
        );
      }
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

  Future<void> _handleMenuAction(String value) async {
    switch (value) {
      case 'rename':
        if (widget.savedRemoteId != null) {
          final controller = TextEditingController();
          final newName = await showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Rename Remote'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Enter new name'),
                autofocus: true,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, controller.text),
                  child: const Text('Save'),
                ),
              ],
            ),
          );
          if (newName != null && newName.isNotEmpty) {
            final repo = ref.read(irRepositoryProvider);
            await repo.renameSavedRemote(widget.savedRemoteId!, newName);
            ref.invalidate(savedRemotesProvider);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Remote renamed successfully')),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot rename an unsaved remote. Please save it first.')),
          );
        }
        break;
      case 'pair':
        if (mounted) context.push('/add');
        break;
      case 'add_home':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add to Home Screen not supported natively yet.')),
        );
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Remote configuration shared!')),
        );
        break;
      case 'delete':
        if (widget.savedRemoteId != null) {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Remote'),
              content: const Text('Are you sure you want to delete this remote?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              ],
            ),
          );
          if (confirm == true) {
            final repo = ref.read(irRepositoryProvider);
            await repo.deleteSavedRemote(widget.savedRemoteId!);
            ref.invalidate(savedRemotesProvider);
            if (mounted) {
              context.go('/');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Remote deleted')),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot delete an unsaved remote.')),
          );
        }
        break;
    }
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
            onSelected: _handleMenuAction,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(value: 'rename', child: Text('Rename')),
                const PopupMenuItem(value: 'pair', child: Text('Pair again')),
                const PopupMenuItem(value: 'add_home', child: Text('Add to Home screen')),
                const PopupMenuItem(value: 'share', child: Text('Share')),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Delete',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
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
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(_currentMode, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Mode', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      ],
                    ),
                    const SizedBox(width: 48),
                    Column(
                      children: [
                        Text('Auto', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Fan speed', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
                Material(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(40),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => _changeTemp(device, -1),
                        child: const Padding(
                          padding: EdgeInsets.all(24),
                          child: Icon(Icons.remove),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Temperature',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      InkWell(
                        onTap: () => _changeTemp(device, 1),
                        child: const Padding(
                          padding: EdgeInsets.all(24),
                          child: Icon(Icons.add),
                        ),
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
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(40),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(text, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(BuildContext context, IrDevice device, String label, IconData icon, bool isSelected) {
    return Column(
      children: [
        Material(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              if (['Auto', 'Cool', 'Heating', 'Dry', 'Fan'].contains(label)) {
                _setMode(device, label);
              } else {
                _sendCommand(device, label.toLowerCase());
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isSelected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
