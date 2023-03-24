package com.busition.user

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.util.Log
import androidx.core.app.ActivityCompat

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.busition.user/bluetooth"
    val bAdapter = BluetoothAdapter.getDefaultAdapter()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
             btON()
        }
    }

    private fun btON() {
        startActivityForResult(Intent(BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE),1)
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.BLUETOOTH_SCAN
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return
        }
        if (bAdapter!!.isDiscovering) {
            Log.d("여기까지 왔을까요?", "제발..2")
            // startActivityForResult(Intent(BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE),1)
        }
        else{
            Log.d("여기까지 왔을까요?", "제발..3")
        }
    }


}
