import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:random_word_chat/models/room.dart';
import 'package:random_word_chat/screens/chatroom.dart';
import 'package:random_word_chat/utils/constants/custom_color.dart';
import 'package:random_word_chat/widgets/buttons/btn_join_select.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _roomCreateController = TextEditingController();
  final TextEditingController _roomEnterController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  void _onJoinRoom(Room room) {
    Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => ChatRoom(
                  room: room,
                  myName: _userNameController.text,
                )));
  }

  Future<void> _onSubmitRoom(BuildContext context) async {
    if (_roomCreateController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty) {
      final response = await http.post(
          Uri.parse("http://43.200.100.168:8080/api/chat/create"),
          body: <String, String>{"name": _roomCreateController.text});

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        Room room = Room.fromJson(responseData);

        _onJoinRoom(room);
      } else {
        print('방 생성 실패: ${response.statusCode}');
      }
    }
  }

  void _onEnterRoom(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("방 ID와 이름"),
                          TextField(controller: _roomEnterController),
                          TextField(controller: _userNameController),
                          BtnJoinSelect(
                              title: "생성",
                              onPressed: (context) {
                                Room room =
                                    Room(roomId: _roomEnterController.text);

                                _onJoinRoom(room);
                              })
                        ]),
                  )));
        });
  }

  void _onCreateRoom(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("방 제목"),
                          TextField(controller: _roomCreateController),
                          TextField(controller: _userNameController),
                          BtnJoinSelect(title: "생성", onPressed: _onSubmitRoom)
                        ]),
                  )));
        });
  }

  @override
  void dispose() {
    _roomCreateController.dispose();
    _roomEnterController.dispose();
    _userNameController.dispose();
    super.dispose();
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
                      BtnJoinSelect(title: "방 입장하기", onPressed: _onEnterRoom)
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
