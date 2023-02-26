import 'package:flutter/cupertino.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({Key? key}) : super(key: key);

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
          child: Text(
            "Page 4",
            style: TextStyle(fontSize: 50),
          )
      );
  }
}
