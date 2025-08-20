package portal.mn.ticket

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class ApplePayMethodChannel(flutterEngine: FlutterEngine) {
    private val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "apple_pay_channel")

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "testConnection" -> {
                    // Test connection always returns success on Android
                    result.success(true)
                }
                "isApplePaySupported" -> {
                    // Apple Pay is not supported on Android
                    result.success(false)
                }
                else -> {
                    // For all other methods, inform that Apple Pay is not available
                    result.error(
                        "UNSUPPORTED_PLATFORM",
                        "Apple Pay is not supported on Android",
                        null
                    )
                }
            }
        }
    }
}