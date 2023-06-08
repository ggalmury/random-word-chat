import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:random_word_chat/models/message.dart';
import 'package:random_word_chat/widgets/boxes/chat_message.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/room.dart';
import '../utils/constants/custom_color.dart';

class ChatRoom extends StatefulWidget {
  final WebSocketChannel channel =
      IOWebSocketChannel.connect("ws://43.200.100.168:8080/room");
  final Room room;
  final String myName;

  ChatRoom({super.key, required this.room, required this.myName});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messageList = [];

  void _scrollToNewChild() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  void _onMessage(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      Message message = Message.fromJson(jsonDecode(snapshot.data));

      _messageList.add(message);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _emitMessage() {
    if (_textEditingController.text.isNotEmpty) {
      Message message = Message(
          type: "talk",
          roomId: widget.room.roomId,
          sender: widget.myName,
          message: _textEditingController.text);

      widget.channel.sink.add(jsonEncode(message));
    }

    _scrollToNewChild();
    _textEditingController.clear();
  }

  @override
  void initState() {
    super.initState();
    print(widget.room.roomId);

    Message message = Message(
        type: "new",
        roomId: widget.room.roomId,
        sender: widget.myName,
        message: "");

    widget.channel.sink.add(jsonEncode(message));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    widget.channel.sink.close();

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
                SizedBox(
                  height: 50,
                  child: Center(child: Text(widget.room.roomId)),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: StreamBuilder(
                      stream: widget.channel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _onMessage(snapshot);
                        }
                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: _messageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_messageList[index].sender),
                                        ChatMessage(
                                          meta: _messageList[index],
                                          currentUser: widget.myName,
                                        )
                                      ])
                                ]),
                              );
                            });
                      }),
                )),
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
