import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/saved_remote.dart';
import 'ir_provider.dart';

final savedRemotesProvider = FutureProvider<List<SavedRemote>>((ref) async {
  final repo = ref.watch(irRepositoryProvider);
  return await repo.getSavedRemotes();
});
