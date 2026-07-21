import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/ir_device.dart';
import '../../home/providers/ir_provider.dart';
import '../providers/remote_provider.dart';
import '../widgets/remote_button.dart';

class TvRemoteScreen extends ConsumerWidget {
  final int deviceId;

  const TvRemoteScreen({super.key, required this.deviceId});

  void _sendCommand(WidgetRef ref, IrDevice device, String command) async {
    final pattern = device.buttons[command];
    if (pattern != null) {
      final repo = ref.read(irRepositoryProvider);
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
      ),
      body: deviceAsync.when(
        data: (device) {
          if (device == null) {
            return const Center(child: Text('Device not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Top row: Power and Mute
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RemoteButton(
                      icon: Icons.power_settings_new,
                      color: Colors.red,
                      onPressed: () => _sendCommand(ref, device, 'power'),
                    ),
                    RemoteButton(
                      icon: Icons.volume_off,
                      onPressed: () => _sendCommand(ref, device, 'mute'),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                // Volume and Channel
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRocker(
                      context,
                      'VOL',
                      Icons.add,
                      Icons.remove,
                      () => _sendCommand(ref, device, 'vol_up'),
                      () => _sendCommand(ref, device, 'vol_down'),
                    ),
                    _buildRocker(
                      context,
                      'CH',
                      Icons.keyboard_arrow_up,
                      Icons.keyboard_arrow_down,
                      () => _sendCommand(ref, device, 'ch_up'),
                      () => _sendCommand(ref, device, 'ch_down'),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                // D-Pad
                _buildDPad(ref, device),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          IconButton(
            icon: Icon(upIcon),
            iconSize: 32,
            onPressed: onUp,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: Icon(downIcon),
            iconSize: 32,
            onPressed: onDown,
          ),
        ],
      ),
    );
  }

  Widget _buildDPad(WidgetRef ref, IrDevice device) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: RemoteButton(
              icon: Icons.keyboard_arrow_up,
              onPressed: () => _sendCommand(ref, device, 'up'),
            ),
          ),
          Positioned(
            bottom: 0,
            child: RemoteButton(
              icon: Icons.keyboard_arrow_down,
              onPressed: () => _sendCommand(ref, device, 'down'),
            ),
          ),
          Positioned(
            left: 0,
            child: RemoteButton(
              icon: Icons.keyboard_arrow_left,
              onPressed: () => _sendCommand(ref, device, 'left'),
            ),
          ),
          Positioned(
            right: 0,
            child: RemoteButton(
              icon: Icons.keyboard_arrow_right,
              onPressed: () => _sendCommand(ref, device, 'right'),
            ),
          ),
          Center(
            child: RemoteButton(
              text: 'OK',
              color: Colors.blue,
              onPressed: () => _sendCommand(ref, device, 'ok'),
            ),
          ),
        ],
      ),
    );
  }
}
