import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/ir_device.dart';
import '../../home/providers/ir_provider.dart';

final deviceByIdProvider = FutureProvider.family<IrDevice?, int>((ref, id) async {
  final repo = ref.watch(irRepositoryProvider);
  return await repo.getDeviceById(id);
});
