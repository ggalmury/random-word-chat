import 'package:flutter/material.dart';
import 'package:random_word_chat/models/room.dart';
import 'package:random_word_chat/repositories/room_repository.dart';
import 'package:random_word_chat/screens/chatroom.dart';
import 'package:random_word_chat/screens/room_list.dart';
import 'package:random_word_chat/widgets/buttons/btn_join_select.dart';
import 'package:random_word_chat/widgets/modals/room_creact_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _roomIdController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  void _navigateHandler(Widget widget) {
    Navigator.push<void>(context,
        MaterialPageRoute<void>(builder: (BuildContext context) => widget));
  }

  void _gotoJoinedRoom(BuildContext context) {
    if (_roomIdController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty) {
      Room room = Room(roomId: _roomIdController.text);

      _navigateHandler(ChatRoom(room: room, myName: _userNameController.text));
    }
  }

  Future<void> _gotoCreatedRoom(BuildContext context) async {
    if (_roomIdController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty) {
      Room room = await RoomRepository().fetchRoomId(_roomIdController.text);

      _navigateHandler(ChatRoom(room: room, myName: _userNameController.text));
    }
  }

  void _gotoRoomList(BuildContext context) {
    _navigateHandler(RoomList());
  }

  void _onCreateRoom(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return RoomCreateDialog(
              title: "방 생성하기",
              title1: "방 이름",
              title2: "닉네임",
              btnText: "확인",
              roomController: _roomIdController,
              nameController: _userNameController,
              onSubmit: _gotoCreatedRoom);
        }).then((value) {
      _roomIdController.clear();
      _userNameController.clear();
    });
  }

  void _onEnterRoom(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return RoomCreateDialog(
            title: "방 참가하기",
            title1: "방 ID",
            title2: "닉네임",
            btnText: "확인",
            roomController: _roomIdController,
            nameController: _userNameController,
            onSubmit: _gotoJoinedRoom);
      },
    ).then((value) {
      _roomIdController.clear();
      _userNameController.clear();
    });
  }

  @override
  void dispose() {
    _roomIdController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("랜덤 알고리즘을 이용한 채팅 어플",
                      style:
                          TextStyle(fontSize: 20, fontFamily: "kangwon_bold")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BtnJoinSelect(title: "방 생성하기", onPressed: _onCreateRoom),
                      BtnJoinSelect(title: "방 입장하기", onPressed: _onEnterRoom),
                      BtnJoinSelect(title: "방 리스트 보기", onPressed: _gotoRoomList)
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
