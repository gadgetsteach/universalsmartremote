// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ir_device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IrDeviceModel _$IrDeviceModelFromJson(Map<String, dynamic> json) =>
    IrDeviceModel(
      id: (json['id'] as num).toInt(),
      category: json['category'] as String,
      brand: json['brand'] as String,
      series: json['series'] as String,
      model: json['model'] as String,
      carrierFrequency: (json['carrierFrequency'] as num).toInt(),
      buttons: (json['buttons'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>).map((e) => (e as num).toInt()).toList(),
        ),
      ),
    );

Map<String, dynamic> _$IrDeviceModelToJson(IrDeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'brand': instance.brand,
      'series': instance.series,
      'model': instance.model,
      'carrierFrequency': instance.carrierFrequency,
      'buttons': instance.buttons,
    };
