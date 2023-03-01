import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:busition_user/busition_user_method_channel.dart';

void main() {
  MethodChannelBusitionUser platform = MethodChannelBusitionUser();
  const MethodChannel channel = MethodChannel('busition_user');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
