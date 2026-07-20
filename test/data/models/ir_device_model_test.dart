import 'package:flutter_test/flutter_test.dart';
import 'package:universalsmartremote/data/models/ir_device_model.dart';
import 'package:universalsmartremote/domain/entities/ir_device.dart';

void main() {
  final Map<String, dynamic> testJson = {
    'id': 1,
    'category': 'TV',
    'brand': 'Samsung',
    'series': 'Series 7',
    'model': 'UA43',
    'carrierFrequency': 38000,
    'buttons': {
      'power': [9000, 4500, 560, 1690],
      'volumeUp': [9000, 4500, 560, 560]
    }
  };

  final IrDeviceModel testModel = IrDeviceModel(
    id: 1,
    category: 'TV',
    brand: 'Samsung',
    series: 'Series 7',
    model: 'UA43',
    carrierFrequency: 38000,
    buttons: {
      'power': [9000, 4500, 560, 1690],
      'volumeUp': [9000, 4500, 560, 560]
    },
  );

  test('fromJson should return a valid model from JSON', () {
    final result = IrDeviceModel.fromJson(testJson);

    expect(result.id, testModel.id);
    expect(result.brand, testModel.brand);
    expect(result.buttons['power'], testModel.buttons['power']);
  });

  test('toJson should return a JSON map containing proper data', () {
    final result = testModel.toJson();

    expect(result, testJson);
  });

  test('toEntity should return an IrDevice', () {
    final result = testModel.toEntity();

    expect(result, isA<IrDevice>());
    expect(result.brand, testModel.brand);
    expect(result.id, testModel.id);
  });
}
