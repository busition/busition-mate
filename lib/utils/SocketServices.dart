
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketServices extends StatefulWidget {
  const SocketServices({Key? key}) : super(key: key);

  @override
  State<SocketServices> createState() => _SocketServicesState();
}

class _SocketServicesState extends State<SocketServices> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(
        children: [
          Container(child: Text("Socket Area"),margin: EdgeInsets.only(top: 8),),
          SizedBox(height: 100, child: TextField(controller: _controller,)),
          Container(
            child: ElevatedButton(
              onPressed: _sendMessage,
              child: Text("Send Text"),
            ),
          ),Container(
            child: ElevatedButton(
              onPressed: _testSend,
              child: Text("Send 0123456789"),
            ),
          ),
          SizedBox(
            height: 200,
            child: StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? 'result: ${snapshot.data}' : '');
              },
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  void _testSend(){
    String a = "";
    for (int i = 0; i < 10; i++){
      a+="$i";
      _channel.sink.add("$a");
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
