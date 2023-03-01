import 'package:flutter_test/flutter_test.dart';
import 'package:busition_user/busition_user.dart';
import 'package:busition_user/busition_user_platform_interface.dart';
import 'package:busition_user/busition_user_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBusitionUserPlatform 
    with MockPlatformInterfaceMixin
    implements BusitionUserPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BusitionUserPlatform initialPlatform = BusitionUserPlatform.instance;

  test('$MethodChannelBusitionUser is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBusitionUser>());
  });

  test('getPlatformVersion', () async {
    BusitionUser busitionUserPlugin = BusitionUser();
    MockBusitionUserPlatform fakePlatform = MockBusitionUserPlatform();
    BusitionUserPlatform.instance = fakePlatform;
  
    expect(await busitionUserPlugin.getPlatformVersion(), '42');
  });
}
