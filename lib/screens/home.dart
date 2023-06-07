import 'package:flutter/material.dart';
import 'package:random_word_chat/screens/chatroom.dart';
import 'package:random_word_chat/utils/constants/custom_color.dart';
import 'package:random_word_chat/widgets/buttons/btn_join_select.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _onCreateRoom(BuildContext context) {
    print("create room");
  }

  void _onJoinRoom(BuildContext context) {
    Navigator.push<void>(context,
        MaterialPageRoute<void>(builder: (BuildContext context) => ChatRoom()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.white,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "랜덤 알고리즘을 이용한 채팅 어플",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "kangwon_bold",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BtnJoinSelect(title: "방 생성하기", onPressed: _onCreateRoom),
                      BtnJoinSelect(title: "방 입장하기", onPressed: _onJoinRoom)
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
