import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      body: Column(
        children: [
          irCheck.when(
            data: (hasIr) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              color: hasIr ? Colors.green.shade100 : Colors.red.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasIr ? Icons.sensors : Icons.sensors_off,
                    color: hasIr ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hasIr
                        ? 'IR Blaster Ready'
                        : 'No IR Blaster Detected',
                    style: TextStyle(
                      color: hasIr ? Colors.green.shade900 : Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (error, stack) => const SizedBox.shrink(),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Device Type',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildCategoryCard(context, 'TV', Icons.tv),
                _buildCategoryCard(context, 'AC', Icons.ac_unit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon) {
    return InkWell(
      onTap: () {
        context.push('/brands/$title');
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
