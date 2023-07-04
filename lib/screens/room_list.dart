import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_word_chat/bloc/last_message_bloc.dart';
import 'package:random_word_chat/bloc/room_bloc.dart';
import 'package:random_word_chat/models/internal/room.dart';
import 'package:random_word_chat/repositories/external/room_api.dart';
import 'package:random_word_chat/utils/constants/custom_color.dart';
import 'package:random_word_chat/widgets/boxes/registered_room.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../models/external/message_dto.dart';
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

  late StompClient _stompClient;

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

  TextStyle _bottomNavigationBarTextStyle() {
    return const TextStyle(fontFamily: "pretendard_medium", fontSize: 10);
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

      if (!mounted) return;

      List<Room> roomList = context.read<RoomBloc>().state.roomList;

      if (!roomList.any((room) => room.roomId == roomDto.roomId)) {
        context.read<RoomBloc>().add(CreateRoomEvent(roomDto: roomDto));
      }
    }
  }

  void _createRoomDialog() {
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
        });
  }

  void _joinRoomDialog() {
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

  void _connectToChatServer() {
    _stompClient = StompClient(
        config: StompConfig.SockJS(
            url: "http://43.200.100.168:8080/chat",
            onConnect: _onConnect,
            onWebSocketError: _onWebSocketError));

    _stompClient.activate();
  }

  void _onConnect(StompFrame stompFrame) {
    List<Room> roomList = context.read<RoomBloc>().state.roomList;

    for (var room in roomList) {
      _stompClient.subscribe(
          destination: '/sub/chat/room/${room.roomId}', callback: _onMessage);

      MessageDto message = MessageDto(
          type: "new", roomId: room.roomId, sender: room.userName, message: "");

      _stompClient.send(
          destination: '/pub/chat/message', body: jsonEncode(message));
    }
  }

  void _onWebSocketError(dynamic error) {
    print(error);
  }

  void _onMessage(StompFrame stompFrame) {
    if (stompFrame.body != null) {
      final jsonMessage = jsonDecode(stompFrame.body!);
      final chatMessage = MessageDto.fromJson(jsonMessage);

      context
          .read<LastMessageBloc>()
          .add(UpdateLastMessageEvent(messageDto: chatMessage));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _connectToChatServer();
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
        selectedLabelStyle: _bottomNavigationBarTextStyle(),
        unselectedLabelStyle: _bottomNavigationBarTextStyle(),
        selectedItemColor: CustomColor.violet,
        currentIndex: _bottomNavigationIndex,
        onTap: _onBottomNavigationItemTap,
      ),
    );
  }
}
