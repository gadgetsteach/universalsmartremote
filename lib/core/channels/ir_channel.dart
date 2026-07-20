import 'package:flutter/services.dart';

class IrChannel {
  static const MethodChannel _channel = MethodChannel('com.example.universalsmartremote/ir');

  static Future<bool> hasIrEmitter() async {
    try {
      final bool hasEmitter = await _channel.invokeMethod('hasIrEmitter');
      return hasEmitter;
    } on PlatformException catch (_) {
      return false;
    }
  }

  static Future<List<Map<String, int>>> getCarrierFrequencies() async {
    try {
      final List<dynamic> freqs = await _channel.invokeMethod('getCarrierFrequencies');
      return freqs.map((e) => Map<String, int>.from(e)).toList();
    } on PlatformException catch (_) {
      return [];
    }
  }

  static Future<bool> transmit({required int carrierFrequency, required List<int> pattern}) async {
    try {
      final bool result = await _channel.invokeMethod('transmit', {
        'carrierFrequency': carrierFrequency,
        'pattern': pattern,
      });
      return result;
    } on PlatformException catch (e) {
      print("Transmit error: ${e.message}");
      return false;
    }
  }
}
