import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_word_chat/bloc/last_message_bloc.dart';
import 'package:random_word_chat/bloc/room_bloc.dart';
import 'package:random_word_chat/repositories/external/room_api.dart';
import 'package:random_word_chat/utils/constants/custom_color.dart';
import 'package:random_word_chat/utils/helpers/stomp_provider.dart';
import 'package:random_word_chat/widgets/boxes/registered_room.dart';
import '../models/external/room_dto.dart';
import '../utils/helpers/common_helper.dart';
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
  int _bottomNavigationIndex = 0;

  void _setBottomNavigationIndex(int index) {
    setState(() {
      _bottomNavigationIndex = index;
    });
  }

  void _bottomNavigationEvent(int index) {
    switch (index) {
      case 0:
        _createRoomDialog();
        break;
      case 1:
        _joinRoomDialog();
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

  Widget _bottomNavigationBarIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Icon(icon),
    );
  }

  Future<void> _gotoCreatedRoom(BuildContext context) async {
    if (_roomIdController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty) {
      RoomDto roomDto = await RoomApi().fetchRoomCreate(_roomIdController.text);
      roomDto.userName = _userNameController.text;

      if (!mounted) return;

      context.read<RoomBloc>().add(CreateRoomEvent(roomDto: roomDto));
    }
  }

  Future<void> _gotoJoinedRoom(BuildContext context) async {
    if (_roomIdController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty) {
      RoomDto roomDto = await RoomApi().fetchRoomJoin(_roomIdController.text);
      roomDto.userName = _userNameController.text;

      if (!mounted) return;

      context.read<RoomBloc>().add(CreateRoomEvent(roomDto: roomDto));
    }
  }

  void _createRoomDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return BlocListener<RoomBloc, DefaultRoomState>(
            listener: (context, state) {
              Navigator.pop(context);

              CommonHelper.navigatePushHandler(
                  context, ChatRoom(room: state.roomList[0]));
            },
            child: RoomCreateDialog(
                title: "방 생성하기",
                title1: "방 이름",
                title2: "닉네임",
                btnText: "확인",
                roomController: _roomIdController,
                nameController: _userNameController,
                onSubmit: _gotoCreatedRoom),
          );
        });
  }

  void _joinRoomDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return BlocListener<RoomBloc, DefaultRoomState>(
            listener: (context, state) {
              Navigator.pop(context);

              CommonHelper.navigatePushHandler(
                  context, ChatRoom(room: state.roomList[0]));
            },
            child: RoomCreateDialog(
                title: "방 참가하기",
                title1: "방 ID",
                title2: "닉네임",
                btnText: "확인",
                roomController: _roomIdController,
                nameController: _userNameController,
                onSubmit: _gotoJoinedRoom),
          );
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    StompProvider()
        .injectBloc(context.read<RoomBloc>(), context.read<LastMessageBloc>());
    StompProvider().connectToChatServer();

    context.read<RoomBloc>().add(GetAllRoomsEvent());
    context.read<LastMessageBloc>().add(GetAllLastMessageEvent());
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
                  Text("rwc",
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
              child: BlocBuilder<RoomBloc, DefaultRoomState>(
                  builder: (context, state) {
                return ListView.builder(
                  itemCount: state.roomList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RegisteredRoom(room: state.roomList[index]);
                  },
                );
              }),
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
        selectedLabelStyle:
            const TextStyle(fontFamily: "pretendard_medium", fontSize: 10),
        unselectedLabelStyle:
            const TextStyle(fontFamily: "pretendard_medium", fontSize: 10),
        selectedItemColor: CustomColor.violet,
        currentIndex: _bottomNavigationIndex,
        onTap: _onBottomNavigationItemTap,
      ),
    );
  }
}
