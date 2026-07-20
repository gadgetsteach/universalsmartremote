import '../entities/ir_device.dart';

abstract class IrRepository {
  Future<List<String>> getSupportedBrands(String category);
  Future<List<IrDevice>> getDevicesForBrand(String brand);
  Future<void> saveDevice(IrDevice device);
  Future<bool> hasIrEmitter();
  Future<bool> transmit(int frequency, List<int> pattern);
}
