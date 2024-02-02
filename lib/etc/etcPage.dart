import "package:flutter/material.dart";

import "../Provider/User.dart";
import "../main.dart";

class EtcPage extends StatefulWidget {
  const EtcPage({super.key});

  @override
  State<EtcPage> createState() => _EtcPageState();
}

List<String> menu = ["로그아웃"];
List<Function> menuFunction = [
  Logout,
];

class _EtcPageState extends State<EtcPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("더보기"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              proFile(),
              Expanded(
                child: ListView.builder(
                  itemCount: menu.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: InkWell(
                      child: Center(
                          child: Text(
                        menu[index],
                      )),
                      onTap: () {
                        return menuFunction[index](context);
                      },
                    ));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget proFile() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    "https://images.pexels.com/photos/221043/pexels-photo-221043.jpeg?cs=srgb&dl=pexels-pixabay-221043.jpg&fm=jpg"),
              ),
            ),
          ),
          Text(User.name),
        ],
      ),
    );
  }
}
