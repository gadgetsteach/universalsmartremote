import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/ir_device.dart';

part 'ir_device_model.g.dart';

@JsonSerializable(explicitToJson: true)
class IrDeviceModel {
  final int id;
  final String category;
  final String brand;
  final String series;
  final String model;
  final int carrierFrequency;
  final Map<String, List<int>> buttons;

  IrDeviceModel({
    required this.id,
    required this.category,
    required this.brand,
    required this.series,
    required this.model,
    required this.carrierFrequency,
    required this.buttons,
  });

  factory IrDeviceModel.fromJson(Map<String, dynamic> json) => _$IrDeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$IrDeviceModelToJson(this);

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
