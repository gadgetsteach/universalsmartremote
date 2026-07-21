import '../../domain/entities/saved_remote.dart';
import 'ir_device_model.dart';

class SavedRemoteModel {
  final int id;
  final String name;
  final int deviceId;
  final IrDeviceModel? device;

  SavedRemoteModel({
    required this.id,
    required this.name,
    required this.deviceId,
    this.device,
  });

  factory SavedRemoteModel.fromJson(Map<String, dynamic> json, {IrDeviceModel? device}) {
    return SavedRemoteModel(
      id: json['id'] as int,
      name: json['name'] as String,
      deviceId: json['device_id'] as int,
      device: device,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'device_id': deviceId,
    };
  }

  SavedRemote toEntity() {
    if (device == null) {
      throw Exception('Device model is required to convert to entity');
    }
    return SavedRemote(
      id: id,
      name: name,
      device: device!.toEntity(),
    );
  }
}
