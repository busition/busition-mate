import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'busition_user_platform_interface.dart';

/// An implementation of [BusitionUserPlatform] that uses method channels.
class MethodChannelBusitionUser extends BusitionUserPlatform {
  /// The method channel used to interact with the native platform.
  /// 메소드채널 생성
  @visibleForTesting
  final methodChannel = const MethodChannel('busition_user');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
