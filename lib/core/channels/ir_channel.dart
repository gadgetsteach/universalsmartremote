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

  static Future<String?> transmit({required int carrierFrequency, required List<int> pattern}) async {
    try {
      final bool result = await _channel.invokeMethod('transmit', {
        'carrierFrequency': carrierFrequency,
        'pattern': pattern,
      });
      if (result) return null; // Success
      return "Unknown error";
    } on PlatformException catch (e) {
      return e.message ?? e.code;
    } catch (e) {
      return e.toString();
    }
  }
}
