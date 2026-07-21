import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/ir_device.dart';
import '../../home/providers/ir_provider.dart';
import '../providers/remote_provider.dart';

class TvRemoteScreen extends ConsumerWidget {
  final int deviceId;

  const TvRemoteScreen({super.key, required this.deviceId});

  void _sendCommand(BuildContext context, WidgetRef ref, IrDevice device, String command) async {
    final pattern = device.buttons[command];
    if (pattern != null) {
      final repo = ref.read(irRepositoryProvider);
      final hasEmitter = await repo.hasIrEmitter();
      if (!hasEmitter) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Simulated sending $command command (No IR Emitter)')),
          );
        }
        return;
      }
      await repo.transmit(device.carrierFrequency, pattern);
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
            onSelected: (value) {},
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

  Widget _buildRocker(
    BuildContext context,
    String label,
    IconData upIcon,
    IconData downIcon,
    VoidCallback onUp,
    VoidCallback onDown,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          IconButton(
            icon: Icon(upIcon),
            iconSize: 32,
            padding: const EdgeInsets.all(24),
            onPressed: onUp,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          IconButton(
            icon: Icon(downIcon),
            iconSize: 32,
            padding: const EdgeInsets.all(24),
            onPressed: onDown,
          ),
        ],
      ),
    );
  }

  Widget _buildDPad(BuildContext context, WidgetRef ref, IrDevice device) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 16,
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_up, size: 40),
              onPressed: () => _sendCommand(context, ref, device, 'up'),
            ),
          ),
          Positioned(
            bottom: 16,
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down, size: 40),
              onPressed: () => _sendCommand(context, ref, device, 'down'),
            ),
          ),
          Positioned(
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_left, size: 40),
              onPressed: () => _sendCommand(context, ref, device, 'left'),
            ),
          ),
          Positioned(
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_right, size: 40),
              onPressed: () => _sendCommand(context, ref, device, 'right'),
            ),
          ),
          Center(
            child: InkWell(
              onTap: () => _sendCommand(context, ref, device, 'ok'),
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
