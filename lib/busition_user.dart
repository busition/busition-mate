
import 'busition_user_platform_interface.dart';

class BusitionUser {
  Future<String?> getPlatformVersion() {
    return BusitionUserPlatform.instance.getPlatformVersion();
  }
}
