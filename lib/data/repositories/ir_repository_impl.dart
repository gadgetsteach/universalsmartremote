import '../../core/channels/ir_channel.dart';
import '../../domain/entities/ir_device.dart';
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
  Future<bool> hasIrEmitter() async {
    return await IrChannel.hasIrEmitter();
  }

  @override
  Future<bool> transmit(int frequency, List<int> pattern) async {
    return await IrChannel.transmit(
      carrierFrequency: frequency,
      pattern: pattern,
    );
  }
}
