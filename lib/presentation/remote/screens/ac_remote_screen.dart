import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/ir_device.dart';
import '../../home/providers/ir_provider.dart';
import '../providers/remote_provider.dart';
import '../widgets/remote_button.dart';

class AcRemoteScreen extends ConsumerStatefulWidget {
  final int deviceId;

  const AcRemoteScreen({super.key, required this.deviceId});

  @override
  ConsumerState<AcRemoteScreen> createState() => _AcRemoteScreenState();
}

class _AcRemoteScreenState extends ConsumerState<AcRemoteScreen> {
  int _currentTemp = 24;
  bool _isOn = false;

  void _sendCommand(IrDevice device, String command) async {
    final pattern = device.buttons[command];
    if (pattern != null) {
      final repo = ref.read(irRepositoryProvider);
      await repo.transmit(device.carrierFrequency, pattern);
    }
  }

  void _togglePower(IrDevice device) {
    setState(() {
      _isOn = !_isOn;
    });
    _sendCommand(device, 'power');
  }

  void _changeTemp(IrDevice device, int delta) {
    if (!_isOn) return;
    setState(() {
      _currentTemp = (_currentTemp + delta).clamp(16, 30);
    });
    _sendCommand(device, delta > 0 ? 'temp_up' : 'temp_down');
  }

  @override
  Widget build(BuildContext context) {
    final deviceAsync = ref.watch(deviceByIdProvider(widget.deviceId));

    return Scaffold(
      appBar: AppBar(
        title: deviceAsync.when(
          data: (device) => Text('${device?.brand ?? ''} AC Remote'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
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
                // AC Display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _isOn ? Colors.teal.shade100 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _isOn ? '$_currentTemp°C' : 'OFF',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: _isOn ? Colors.teal.shade900 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Power Button
                RemoteButton(
                  icon: Icons.power_settings_new,
                  color: _isOn ? Colors.green : Colors.red,
                  onPressed: () => _togglePower(device),
                ),
                const SizedBox(height: 48),
                // Temperature Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RemoteButton(
                      icon: Icons.remove,
                      onPressed: () => _changeTemp(device, -1),
                    ),
                    const Text('TEMP', style: TextStyle(fontWeight: FontWeight.bold)),
                    RemoteButton(
                      icon: Icons.add,
                      onPressed: () => _changeTemp(device, 1),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                // Modes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RemoteButton(
                      text: 'MODE',
                      isCircular: false,
                      onPressed: () {
                        if (_isOn) _sendCommand(device, 'mode');
                      },
                    ),
                    RemoteButton(
                      text: 'FAN',
                      isCircular: false,
                      onPressed: () {
                        if (_isOn) _sendCommand(device, 'fan');
                      },
                    ),
                    RemoteButton(
                      text: 'SWING',
                      isCircular: false,
                      onPressed: () {
                        if (_isOn) _sendCommand(device, 'swing');
                      },
                    ),
                  ],
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
}
