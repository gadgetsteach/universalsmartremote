import '../../core/channels/ir_channel.dart';
import '../../domain/entities/ir_device.dart';
import '../../domain/entities/saved_remote.dart';
import '../../domain/repositories/ir_repository.dart';
import '../datasources/local/sqlite_db.dart';
import '../models/ir_device_model.dart';

class IrRepositoryImpl implements IrRepository {
  final SQLiteDB _localDb;

  IrRepositoryImpl(this._localDb);

  @override
  Future<List<String>> getSupportedBrands(String category) async {
    return await _localDb.getBrandsByCategory(category);
  }

  @override
  Future<List<IrDevice>> getDevicesForBrand(String brand) async {
    final models = await _localDb.getDevicesByBrand(brand);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<IrDevice?> getDeviceById(int id) async {
    final model = await _localDb.getDeviceById(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveDevice(IrDevice device) async {
    final model = IrDeviceModel(
      id: device.id,
      category: device.category,
      brand: device.brand,
      series: device.series,
      model: device.model,
      carrierFrequency: device.carrierFrequency,
      buttons: device.buttons,
    );
    await _localDb.insertDevice(model);
  }

  @override
  Future<int> saveUserRemote(String name, int deviceId) async {
    return await _localDb.saveUserRemote(name, deviceId);
  }

  @override
  Future<List<SavedRemote>> getSavedRemotes() async {
    final models = await _localDb.getSavedRemotes();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> deleteSavedRemote(int id) async {
    await _localDb.deleteSavedRemote(id);
  }

  @override
  Future<void> renameSavedRemote(int id, String newName) async {
    await _localDb.renameSavedRemote(id, newName);
  }

  @override
  Future<bool> hasIrEmitter() async {
    return await IrChannel.hasIrEmitter();
  }

  @override
  Future<String?> transmit(int frequency, List<int> pattern) {
    return IrChannel.transmit(carrierFrequency: frequency, pattern: pattern);
  }
}
