import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/brands_provider.dart';

class BrandListScreen extends ConsumerStatefulWidget {
  final String category;

  const BrandListScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends ConsumerState<BrandListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final brandsAsync = ref.watch(brandsProvider(widget.category));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select brand'),
      ),
      body: brandsAsync.when(
        data: (brands) {
          final filteredBrands = brands.where((b) => b.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              if (_searchQuery.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text('Popular', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ),
              if (_searchQuery.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: brands.take(10).map((brand) {
                      return ActionChip(
                        label: Text(brand),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        onPressed: () {
                          context.push('/test/${widget.category}/$brand');
                        },
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredBrands.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    final brand = filteredBrands[index];
                    return ListTile(
                      title: Text(brand),
                      onTap: () {
                        context.push('/test/${widget.category}/$brand');
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
