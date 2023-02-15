import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'busition_platform_interface.dart';

/// An implementation of [BusitionPlatform] that uses method channels.
class MethodChannelBusition extends BusitionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('busition');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
