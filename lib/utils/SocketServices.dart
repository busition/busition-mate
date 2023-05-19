import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServices {
  late IO.Socket socket;

  SocketServices(){
    socket = IO.io('http://api.dev.busition.com:3000/console',
        IO.OptionBuilder().setTransports(['websocket']).build());}

  bool checkSocket(){
    return socket.connected;
  }

  startSocket(String id) {
    // Dart client
    print("socketStart ${socket}");
    socket.connect();
    socket.onConnect((_) {
      print('connect');
      socket.emit('send_id', {"id": id});
    });
    socket.on('data', (data) => print(data));
    socket.onerror((err) => (print("$err")));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  disconnect() {
    if (socket.connected) {
      socket.disconnect();
    }
  }
}
