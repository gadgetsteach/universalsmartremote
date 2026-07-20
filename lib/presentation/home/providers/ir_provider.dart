import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/local/sqlite_db.dart';
import '../../../data/repositories/ir_repository_impl.dart';
import '../../../domain/repositories/ir_repository.dart';

final localDbProvider = Provider<SQLiteDB>((ref) {
  return SQLiteDB.instance;
});

final irRepositoryProvider = Provider<IrRepository>((ref) {
  final db = ref.watch(localDbProvider);
  return IrRepositoryImpl(db);
});

final irEmitterCheckProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(irRepositoryProvider);
  return await repo.hasIrEmitter();
});
