import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'busition_method_channel.dart';

abstract class BusitionPlatform extends PlatformInterface {
  /// Constructs a BusitionPlatform.
  BusitionPlatform() : super(token: _token);

  static final Object _token = Object();

  static BusitionPlatform _instance = MethodChannelBusition();

  /// The default instance of [BusitionPlatform] to use.
  ///
  /// Defaults to [MethodChannelBusition].
  static BusitionPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BusitionPlatform] when
  /// they register themselves.
  static set instance(BusitionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
