import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_word_chat/models/message.dart';
import 'package:random_word_chat/utils/helpers/common_helper.dart';
import 'package:random_word_chat/widgets/boxes/speech_bubble.dart';
import 'package:random_word_chat/widgets/boxes/other_message.dart';
import 'package:random_word_chat/widgets/inputs/input_message.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../models/room.dart';

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
          ? SpeechBubble(
              meta: message, isMyMessage: message.sender == widget.myName)
          : OtherMessage(
              meta: message, isMyMessage: message.sender == widget.myName);
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
            // TODO: 환경변수로 빼놓기
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
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
