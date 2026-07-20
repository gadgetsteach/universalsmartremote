import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ir_device.dart';

part 'ir_device_model.freezed.dart';
part 'ir_device_model.g.dart';

@freezed
class IrDeviceModel with _$IrDeviceModel {
  const IrDeviceModel._();

  const factory IrDeviceModel({
    required int id,
    required String category,
    required String brand,
    required String series,
    required String model,
    required int carrierFrequency,
    required Map<String, List<int>> buttons,
  }) = _IrDeviceModel;

  factory IrDeviceModel.fromJson(Map<String, dynamic> json) => _$IrDeviceModelFromJson(json);

  IrDevice toEntity() {
    return IrDevice(
      id: id,
      category: category,
      brand: brand,
      series: series,
      model: model,
      carrierFrequency: carrierFrequency,
      buttons: buttons,
    );
  }
}
