import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/ir_device.dart';
import '../../home/providers/ir_provider.dart';
import '../../home/providers/saved_remotes_provider.dart';
import '../providers/remote_provider.dart';

class TvRemoteScreen extends ConsumerWidget {
  final int deviceId;
  final int? savedRemoteId;

  const TvRemoteScreen({super.key, required this.deviceId, this.savedRemoteId});

  Future<void> _handleMenuAction(BuildContext context, WidgetRef ref, String value) async {
    switch (value) {
      case 'rename':
        if (savedRemoteId != null) {
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
            await repo.renameSavedRemote(savedRemoteId!, newName);
            ref.invalidate(savedRemotesProvider);
            if (context.mounted) {
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
        context.push('/add');
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
        if (savedRemoteId != null) {
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
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          if (confirm == true) {
            final repo = ref.read(irRepositoryProvider);
            await repo.deleteSavedRemote(savedRemoteId!);
            ref.invalidate(savedRemotesProvider);
            if (context.mounted) {
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

  void _sendCommand(BuildContext context, WidgetRef ref, IrDevice device, String command) async {
    HapticFeedback.lightImpact();
    final pattern = device.buttons[command];
    if (pattern != null) {
      final repo = ref.read(irRepositoryProvider);
      final hasEmitter = await repo.hasIrEmitter();
      if (!hasEmitter) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Simulated sending $command command (No IR Emitter)')),
        );
        return;
      }
      final success = await repo.transmit(device.carrierFrequency, pattern);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success ? 'Sent $command command' : 'Failed to send $command')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceAsync = ref.watch(deviceByIdProvider(deviceId));

    return Scaffold(
      appBar: AppBar(
        title: deviceAsync.when(
          data: (device) => Text('${device?.brand ?? ''} TV Remote'),
          loading: () => const Text('Loading...'),
          error: (_, _) => const Text('Error'),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, ref, value),
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
                // Top row: Power and Mute
                Row(
                  children: [
                    Expanded(
                      child: _buildPillButton(
                        context,
                        Icons.power_settings_new,
                        'Power',
                        iconColor: Colors.red,
                        onTap: () => _sendCommand(context, ref, device, 'power'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPillButton(
                        context,
                        Icons.volume_off,
                        'Mute',
                        onTap: () => _sendCommand(context, ref, device, 'mute'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Volume and Channel
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRocker(
                      context,
                      'VOL',
                      Icons.add,
                      Icons.remove,
                      () => _sendCommand(context, ref, device, 'vol_up'),
                      () => _sendCommand(context, ref, device, 'vol_down'),
                    ),
                    _buildRocker(
                      context,
                      'CH',
                      Icons.keyboard_arrow_up,
                      Icons.keyboard_arrow_down,
                      () => _sendCommand(context, ref, device, 'ch_up'),
                      () => _sendCommand(context, ref, device, 'ch_down'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // D-Pad
                _buildDPad(context, ref, device),
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
              Text(text, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRocker(
    BuildContext context,
    String label,
    IconData upIcon,
    IconData downIcon,
    VoidCallback onUp,
    VoidCallback onDown,
  ) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(32),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onUp,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Icon(upIcon, size: 32),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          InkWell(
            onTap: onDown,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Icon(downIcon, size: 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDPad(BuildContext context, WidgetRef ref, IrDevice device) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 8,
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_up, size: 40),
                onPressed: () => _sendCommand(context, ref, device, 'up'),
              ),
            ),
            Positioned(
              bottom: 8,
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down, size: 40),
                onPressed: () => _sendCommand(context, ref, device, 'down'),
              ),
            ),
            Positioned(
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_left, size: 40),
                onPressed: () => _sendCommand(context, ref, device, 'left'),
              ),
            ),
            Positioned(
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_right, size: 40),
                onPressed: () => _sendCommand(context, ref, device, 'right'),
              ),
            ),
            Center(
              child: Material(
                color: Colors.white.withValues(alpha: 0.1),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _sendCommand(context, ref, device, 'ok'),
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
