import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/ir_device.dart';
import '../../home/providers/ir_provider.dart';
import '../providers/brands_provider.dart';

class RemoteTestScreen extends ConsumerStatefulWidget {
  final String category;
  final String brand;

  const RemoteTestScreen({
    super.key,
    required this.category,
    required this.brand,
  });

  @override
  ConsumerState<RemoteTestScreen> createState() => _RemoteTestScreenState();
}

class _RemoteTestScreenState extends ConsumerState<RemoteTestScreen> {
  int _currentIndex = 0;

  void _testPower(IrDevice device) async {
    final repo = ref.read(irRepositoryProvider);
    final powerPattern = device.buttons['power'];
    if (powerPattern != null) {
      final success = await repo.transmit(device.carrierFrequency, powerPattern);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success ? 'Signal sent!' : 'Failed to send signal.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(devicesByBrandProvider(widget.brand));

    return Scaffold(
      appBar: AppBar(
        title: Text('Test ${widget.brand} ${widget.category}'),
      ),
      body: devicesAsync.when(
        data: (devices) {
          if (devices.isEmpty) {
            return const Center(child: Text('No remotes found for this brand.'));
          }

          final currentDevice = devices[_currentIndex];

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Configuration ${_currentIndex + 1} of ${devices.length}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Point your phone at the device and press the power button below.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                InkWell(
                  onTap: () => _testPower(currentDevice),
                  borderRadius: BorderRadius.circular(64),
                  child: Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 16,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.power_settings_new, size: 64, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 48),
                const Text('Did the device turn on/off?'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_currentIndex < devices.length - 1) {
                          setState(() {
                            _currentIndex++;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No more configurations to test.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('No, Next Config'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final route = widget.category.toLowerCase() == 'tv' ? '/remote/tv' : '/remote/ac';
                        context.push('$route/${currentDevice.id}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Yes, It Works!'),
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
