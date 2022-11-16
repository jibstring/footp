package com.example.app_footp

import android.os.Bundle
// import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.Intent
import android.content.Intent.URI_INTENT_SCHEME
import java.net.URISyntaxException
import android.content.ActivityNotFoundException

class MainActivity: FlutterActivity() {
    private var CHANNEL = "fcm_default_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        GeneratedPluginRegistrant.registerWith(flutterEngine!!)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
        
            when {
                call.method.equals("getAppUrl") -> {
                    try {
                    
                        val url: String = call.argument("url")!!
                        val intent = Intent.parseUri(url, URI_INTENT_SCHEME)
                        result.success(intent.dataString)

                    } catch (e: URISyntaxException) {
                        result.notImplemented()
                    } catch (e: ActivityNotFoundException) {
                        result.notImplemented()
                    }
                }
        }
    }
}
}
