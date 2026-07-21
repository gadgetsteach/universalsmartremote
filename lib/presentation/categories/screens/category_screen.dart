import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add manually'),
        actions: [
          IconButton(
            icon: const Icon(Icons.document_scanner_outlined),
            onPressed: () {}, // Scan function not implemented
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Add by device type',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildCategoryCard(context, 'Air conditioner', Icons.ac_unit, 'AC'),
                _buildCategoryCard(context, 'TV', Icons.tv, 'TV'),
                _buildCategoryCard(context, 'Smart TV box', Icons.tv_rounded, 'TV'),
                _buildCategoryCard(context, 'DVD player', Icons.disc_full, 'TV'),
                _buildCategoryCard(context, 'Cable box', Icons.router, 'TV'),
                _buildCategoryCard(context, 'Projector', Icons.videocam, 'TV'),
                _buildCategoryCard(context, 'AV receiver', Icons.speaker, 'TV'),
                _buildCategoryCard(context, 'Fans', Icons.cyclone, 'AC'),
                _buildCategoryCard(context, 'Camera', Icons.camera_alt, 'TV'),
                _buildCategoryCard(context, 'Lights', Icons.lightbulb, 'TV'),
                _buildCategoryCard(context, 'Air purifier', Icons.air, 'AC'),
                _buildCategoryCard(context, 'Water heater', Icons.water_drop, 'AC'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, String backendCategory) {
    return InkWell(
      onTap: () {
        context.push('/brands/$backendCategory');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Icon(icon, size: 40, color: Colors.grey.shade400)),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
