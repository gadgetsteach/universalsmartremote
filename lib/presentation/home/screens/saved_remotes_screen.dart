import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/saved_remotes_provider.dart';

class SavedRemotesScreen extends ConsumerWidget {
  const SavedRemotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedRemotesAsync = ref.watch(savedRemotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IR Remote', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            savedRemotesAsync.when(
              data: (remotes) => Text(
                '${remotes.length} remotes',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              loading: () => const Text('Loading...'),
              error: (_, _) => const Text('Error'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: savedRemotesAsync.when(
                data: (remotes) {
                  if (remotes.isEmpty) {
                    return const Center(child: Text('No saved remotes. Tap + to add one.'));
                  }
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: remotes.length,
                    itemBuilder: (context, index) {
                      final remote = remotes[index];
                      return InkWell(
                        onTap: () {
                          final route = remote.device.category.toLowerCase() == 'tv' ? '/remote/tv' : '/remote/ac';
                          context.push('$route/${remote.device.id}?savedId=${remote.id}');
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                remote.device.category.toLowerCase() == 'tv' ? Icons.tv : Icons.ac_unit,
                                size: 64,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(height: 24),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  remote.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add');
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
