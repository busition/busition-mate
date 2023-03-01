import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'busition_user_method_channel.dart';

abstract class BusitionUserPlatform extends PlatformInterface {
  /// Constructs a BusitionUserPlatform.
  BusitionUserPlatform() : super(token: _token);

  static final Object _token = Object();

  static BusitionUserPlatform _instance = MethodChannelBusitionUser();

  /// The default instance of [BusitionUserPlatform] to use.
  ///
  /// Defaults to [MethodChannelBusitionUser].
  static BusitionUserPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BusitionUserPlatform] when
  /// they register themselves.
  static set instance(BusitionUserPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
