import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_word_chat/models/external/message_dto.dart';
import 'package:random_word_chat/utils/helpers/common_helper.dart';
import 'package:random_word_chat/widgets/boxes/speech_bubble.dart';
import 'package:random_word_chat/widgets/boxes/other_message.dart';
import 'package:random_word_chat/widgets/inputs/input_message.dart';
import 'package:stomp_dart_client/stomp.dart';
import '../models/external/room_dto.dart';
import '../models/internal/room.dart';

class ChatRoom extends StatefulWidget {
  final Room room;
  final StompClient stompClient;

  const ChatRoom({super.key, required this.room, required this.stompClient});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<RoomDto> _messageList = [];

  void _copyRoomId() {
    Clipboard.setData(ClipboardData(text: widget.room.roomId));
    CommonHelper.showSnackBar(context, "클립보드에 복사되었습니다");
  }

  Widget _messageBox(MessageDto message) {
    Widget chat;

    if (message.type == "new") {
      chat = Center(
          child: Text(
        "👋${message.message}",
        style: const TextStyle(fontFamily: "pretendard_medium"),
      ));
    } else {
      chat = message.sender == widget.room.userName
          ? SpeechBubble(
              meta: message,
              isMyMessage: message.sender == widget.room.userName)
          : OtherMessage(
              meta: message,
              isMyMessage: message.sender == widget.room.userName);
    }

    return chat;
  }

  void _emitHandler(MessageDto message) {
    widget.stompClient
        .send(destination: '/pub/chat/message', body: jsonEncode(message));
  }

  void _emitMessage() {
    if (_textEditingController.text.isNotEmpty) {
      MessageDto message = MessageDto(
          type: "talk",
          roomId: widget.room.roomId,
          sender: widget.room.userName,
          message: _textEditingController.text);

      _emitHandler(message);
    }

    _textEditingController.clear();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("방 이름",
                style: TextStyle(fontSize: 16, fontFamily: "suit_heavy")),
            centerTitle: true,
            backgroundColor: Colors.transparent),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        child: Center(
                            child: Text("초대 코드: ${widget.room.roomId}",
                                style: const TextStyle(
                                    fontSize: 12, fontFamily: "suit_heavy"))),
                      ),
                      GestureDetector(
                        onTap: _copyRoomId,
                        child: const Icon(Icons.copy, size: 20),
                      )
                    ]),
                // Expanded(
                //     child: Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 10),
                //         child: ListView.builder(
                //             controller: _scrollController,
                //             itemCount: _messageList.length,
                //             itemBuilder: (BuildContext context, int index) {
                //               return Padding(
                //                   padding:
                //                       const EdgeInsets.symmetric(vertical: 10),
                //                   child: _messageBox(_messageList[index]));
                //             }))),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InputMessage(
                          textEditingController: _textEditingController,
                          focusNode: _focusNode,
                        ),
                        GestureDetector(
                          onTap: _emitMessage,
                          child: const Icon(Icons.send),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ));
  }
}
