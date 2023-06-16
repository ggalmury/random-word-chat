import 'package:flutter/material.dart';
import 'package:random_word_chat/utils/constants/custom_color.dart';
import 'package:random_word_chat/utils/helpers/common_helper.dart';
import 'package:random_word_chat/widgets/boxes/registered_room.dart';
import '../models/room.dart';
import '../repositories/room_repository.dart';
import '../widgets/buttons/btn_room_category.dart';
import '../widgets/modals/room_creact_dialog.dart';
import 'chatroom.dart';

class RoomList extends StatefulWidget {
  const RoomList({super.key});

  @override
  State<RoomList> createState() => _RoolListState();
}

class _RoolListState extends State<RoomList> {
  final TextEditingController _roomIdController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  List<String> tempList = [
    "방1",
    "방2",
    "방3",
    "방4",
    "방5",
    "방6",
    "방7",
    "방8",
    "방9"
  ];
  int _bottomNavigationIndex = 0;

  void _setBottomNavigationIndex(int index) {
    setState(() {
      _bottomNavigationIndex = index;
    });
  }

  void _bottomNavigationEvent(int index) {
    switch (index) {
      case 0:
        _createRoomDialog(context);
        break;
      case 1:
        _joinRoomDialog(context);
        break;
      case 2:
        print("설정");
        break;
      default:
        print("기본");
        break;
    }
  }

  void _onBottomNavigationItemTap(int index) {
    _setBottomNavigationIndex(index);
    _bottomNavigationEvent(index);
  }

  Future<void> _gotoCreatedRoom(BuildContext context) async {
    if (_roomIdController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty) {
      Room room = await RoomRepository().fetchRoomId(_roomIdController.text);

      if (!mounted) return;

      CommonHelper.navigatePushHandler(
          context, ChatRoom(room: room, myName: _userNameController.text));
    }
  }

  void _gotoJoinedRoom(BuildContext context) {
    if (_roomIdController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty) {
      Room room = Room(roomId: _roomIdController.text);

      CommonHelper.navigatePushHandler(
          context, ChatRoom(room: room, myName: _userNameController.text));
    }
  }

  void _createRoomDialog(BuildContext context) {
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

  void _joinRoomDialog(BuildContext context) {
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

  TextStyle _bottomNavigationBarTextStyle() {
    return const TextStyle(fontFamily: "pretendard_medium", fontSize: 10);
  }

  Widget _bottomNavigationBarIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Icon(icon),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Text("랜덤 알고리즘 채팅",
                      style: TextStyle(fontFamily: "suit_heavy", fontSize: 16)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BtnRoomCategory(title: "전체"),
                      BtnRoomCategory(title: "공개"),
                      BtnRoomCategory(title: "비공개"),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tempList.length,
                itemBuilder: (BuildContext context, int index) {
                  return RegisteredRoom(testRoomName: tempList[index]);
                },
              ),
            )
          ],
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: _bottomNavigationBarIcon(Icons.add_comment), label: "방 추가"),
          BottomNavigationBarItem(
              icon: _bottomNavigationBarIcon(Icons.comment), label: "방 입장"),
          BottomNavigationBarItem(
              icon: _bottomNavigationBarIcon(Icons.settings), label: "설정")
        ],
        selectedLabelStyle: _bottomNavigationBarTextStyle(),
        unselectedLabelStyle: _bottomNavigationBarTextStyle(),
        selectedItemColor: CustomColor.violet,
        currentIndex: _bottomNavigationIndex,
        onTap: _onBottomNavigationItemTap,
      ),
    );
  }
}
