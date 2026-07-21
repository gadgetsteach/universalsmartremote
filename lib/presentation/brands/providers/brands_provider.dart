import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/providers/ir_provider.dart';
import '../../../domain/entities/ir_device.dart';

final brandsProvider = FutureProvider.family<List<String>, String>((ref, category) async {
  final repo = ref.watch(irRepositoryProvider);
  return await repo.getSupportedBrands(category);
});

final devicesByBrandProvider = FutureProvider.family<List<IrDevice>, String>((ref, brand) async {
  final repo = ref.watch(irRepositoryProvider);
  return await repo.getDevicesForBrand(brand);
});
