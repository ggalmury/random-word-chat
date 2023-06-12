import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_word_chat/models/message.dart';
import 'package:random_word_chat/utils/helpers/common_helper.dart';
import 'package:random_word_chat/widgets/boxes/speech_bubble.dart';
import 'package:random_word_chat/widgets/boxes/other_message.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../models/room.dart';
import '../utils/constants/custom_color.dart';

class ChatRoom extends StatefulWidget {
  final Room room;
  final String myName;

  const ChatRoom({super.key, required this.room, required this.myName});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messageList = [];

  late StompClient _stompClient;

  void _copyRoomId() {
    Clipboard.setData(ClipboardData(text: widget.room.roomId));
    CommonHelper.showSnackBar(context, "클립보드에 복사되었습니다");
  }

  Widget _messageBox(Message message) {
    Widget chat;

    if (message.type == "new") {
      chat = Center(
          child: Text(
        "👋${message.message}",
        style: const TextStyle(fontFamily: "pretendard_medium"),
      ));
    } else {
      chat = message.sender == widget.myName
          ? Align(
              alignment: Alignment.centerRight,
              child: SpeechBubble(meta: message, currentUser: widget.myName),
            )
          : Align(
              alignment: Alignment.centerLeft,
              child: OtherMessage(meta: message, currentUser: widget.myName),
            );
    }

    return chat;
  }

  void _emitHandler(Message message) {
    _stompClient.send(
        destination: '/pub/chat/message', body: jsonEncode(message));
  }

  void _emitMessage() {
    if (_textEditingController.text.isNotEmpty) {
      Message message = Message(
          type: "talk",
          roomId: widget.room.roomId,
          sender: widget.myName,
          message: _textEditingController.text);

      _emitHandler(message);
    }

    _textEditingController.clear();
  }

  void _onMessage(StompFrame stompFrame) {
    if (stompFrame.body != null) {
      final jsonMessage = jsonDecode(stompFrame.body!);
      final chatMessage = Message.fromJson(jsonMessage);

      setState(() {
        _messageList.add(chatMessage);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  void _onConnect(StompFrame stompFrame) {
    _stompClient.subscribe(
        destination: '/sub/chat/room/${widget.room.roomId}',
        callback: _onMessage);

    Message message = Message(
        type: "new",
        roomId: widget.room.roomId,
        sender: widget.myName,
        message: "");

    _emitHandler(message);
  }

  void _onWebSocketError(dynamic error) {
    print(error);
  }

  void _connectToChatServer() {
    _stompClient = StompClient(
        config: StompConfig.SockJS(
            url: "http://43.200.100.168:8080/chat",
            onConnect: _onConnect,
            onWebSocketError: _onWebSocketError));

    _stompClient.activate();
  }

  @override
  void initState() {
    super.initState();

    print(widget.room.roomId);

    _connectToChatServer();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _stompClient.deactivate();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey, width: 2));
    return Scaffold(
        backgroundColor: CustomColor.white,
        appBar: AppBar(
            title: const Text(
              "방 이름",
              style: TextStyle(fontSize: 16, fontFamily: "suit_heavy"),
            ),
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
                            child: Text(
                          "초대 코드: ${widget.room.roomId}",
                          style: const TextStyle(
                              fontSize: 12, fontFamily: "suit_heavy"),
                        )),
                      ),
                      GestureDetector(
                        onTap: _copyRoomId,
                        child: const Icon(
                          Icons.copy,
                          size: 20,
                        ),
                      )
                    ]),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _messageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: _messageBox(_messageList[index]));
                            }))),
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Center(
                            child: SizedBox(
                              height: 50,
                              child: TextField(
                                focusNode: _focusNode,
                                controller: _textEditingController,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    fontSize: 14, fontFamily: "suit_heavy"),
                                decoration: InputDecoration(
                                  enabledBorder: outlineInputBorder,
                                  focusedBorder: outlineInputBorder,
                                ),
                              ),
                            ),
                          ),
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
