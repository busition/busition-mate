import '../Provider/RealTimeData.dart';
import '../Provider/User.dart';
import '../Schedule/Schedule.dart';
import 'WebSocket.dart';

class SocketManager {
  final Map<int, WebSocketClass> _sockets = {};

  WebSocketClass getSocket(
      int id, User user, RealTimeData realTimeData) {
    if (!_sockets.containsKey(id)) {
      _sockets[id] = WebSocketClass(
          schedule: user.schedule.scheduleData[id]!, user: user, realTimeData: realTimeData);
    }
    return _sockets[id]!;
  }

  void disposeSocket(int scheduleId) {
    _sockets[scheduleId]?.disconnectSocket();
    _sockets.remove(scheduleId);
  }

  Map<int, WebSocketClass> get sockets => _sockets;
}
