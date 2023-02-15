
import 'busition_platform_interface.dart';

class Busition {
  Future<String?> getPlatformVersion() {
    return BusitionPlatform.instance.getPlatformVersion();
  }
}
