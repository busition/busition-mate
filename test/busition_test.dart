import 'package:flutter_test/flutter_test.dart';
import 'package:busition/busition.dart';
import 'package:busition/busition_platform_interface.dart';
import 'package:busition/busition_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBusitionPlatform 
    with MockPlatformInterfaceMixin
    implements BusitionPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BusitionPlatform initialPlatform = BusitionPlatform.instance;

  test('$MethodChannelBusition is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBusition>());
  });

  test('getPlatformVersion', () async {
    Busition busitionPlugin = Busition();
    MockBusitionPlatform fakePlatform = MockBusitionPlatform();
    BusitionPlatform.instance = fakePlatform;
  
    expect(await busitionPlugin.getPlatformVersion(), '42');
  });
}
