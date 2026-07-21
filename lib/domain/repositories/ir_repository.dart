import '../entities/ir_device.dart';
import '../entities/saved_remote.dart';

abstract class IrRepository {
  Future<List<String>> getSupportedBrands(String category);
  Future<List<IrDevice>> getDevicesForBrand(String brand);
  Future<IrDevice?> getDeviceById(int id);
  Future<void> saveDevice(IrDevice device);
  
  Future<int> saveUserRemote(String name, int deviceId);
  Future<List<SavedRemote>> getSavedRemotes();
  Future<void> deleteSavedRemote(int id);
  Future<void> renameSavedRemote(int id, String newName);

  Future<bool> hasIrEmitter();
  Future<bool> transmit(int frequency, List<int> pattern);
}
