package com.example.universalsmartremote

import android.content.Context
import android.hardware.ConsumerIrManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class IrManagerPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var irManager: ConsumerIrManager? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.example.universalsmartremote/ir")
        channel.setMethodCallHandler(this)
        
        irManager = flutterPluginBinding.applicationContext.getSystemService(Context.CONSUMER_IR_SERVICE) as ConsumerIrManager?
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "hasIrEmitter" -> {
                result.success(irManager?.hasIrEmitter() ?: false)
            }
            "getCarrierFrequencies" -> {
                if (irManager?.hasIrEmitter() == true) {
                    val freqs = irManager?.carrierFrequencies
                    val freqList = freqs?.map { 
                        mapOf("min" to it.minFrequency, "max" to it.maxFrequency)
                    } ?: emptyList()
                    result.success(freqList)
                } else {
                    result.success(emptyList<Map<String, Int>>())
                }
            }
            "transmit" -> {
                val carrierFrequency = call.argument<Int>("carrierFrequency")
                val pattern = call.argument<List<Int>>("pattern")?.toIntArray()
                
                if (carrierFrequency != null && pattern != null) {
                    if (irManager?.hasIrEmitter() == true) {
                        try {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                                irManager?.transmit(carrierFrequency, pattern)
                                result.success(true)
                            } else {
                                result.error("UNSUPPORTED_VERSION", "Android version is too old for IR transmission.", null)
                            }
                        } catch (e: Exception) {
                            result.error("TRANSMIT_FAILED", e.message, null)
                        }
                    } else {
                        result.error("NO_IR_EMITTER", "This device does not have an IR emitter.", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENTS", "Carrier frequency and pattern must not be null.", null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
