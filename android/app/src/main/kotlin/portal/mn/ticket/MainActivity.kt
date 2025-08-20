package portal.mn.ticket

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    private lateinit var applePayMethodChannel: ApplePayMethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize the Apple Pay method channel
        applePayMethodChannel = ApplePayMethodChannel(flutterEngine)
    }
}