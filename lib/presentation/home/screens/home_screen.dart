import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ir_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final irCheck = ref.watch(irEmitterCheckProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Universal Smart Remote'),
      ),
      body: Center(
        child: irCheck.when(
          data: (hasIr) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasIr ? Icons.sensors : Icons.sensors_off,
                size: 64,
                color: hasIr ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                hasIr
                    ? 'IR Blaster Detected'
                    : 'This device does not support Infrared.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error checking IR: $error'),
        ),
      ),
    );
  }
}
