import '../Provider/RealTimeData.dart';
import '../Provider/User.dart';
import '../Schedule/Schedule.dart';
import 'WebSocket.dart';

class SocketManager {
  final Map<int, WebSocketClass> _sockets = {};

  WebSocketClass getSocket(
      Schedule schedule, User user, RealTimeData realTimeData) {
    if (!_sockets.containsKey(schedule.id)) {
      _sockets[schedule.id] = WebSocketClass(
          schedule: schedule, user: user, realTimeData: realTimeData);
    }
    return _sockets[schedule.id]!;
  }

  void disposeSocket(int scheduleId) {
    _sockets[scheduleId]?.disconnectSocket();
    _sockets.remove(scheduleId);
  }
}
