import 'package:flutter/material.dart';
import 'package:random_word_chat/models/message.dart';
import 'package:random_word_chat/widgets/boxes/chat_message.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../utils/constants/custom_color.dart';

class ChatRoom extends StatefulWidget {
  final WebSocketChannel channel =
      IOWebSocketChannel.connect("ws://43.200.100.168:8080/room");
  ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messageList = [];

  void scrollToNewChild() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
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
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: StreamBuilder(
                      stream: widget.channel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Message message = Message.init(false, snapshot.data);
                          _messageList.add(message);
                        }
                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: _messageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ChatMessage(meta: _messageList[index]);
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
                          onTap: () {
                            if (_textEditingController.text.isNotEmpty) {
                              widget.channel.sink
                                  .add(_textEditingController.text);
                              Message message = Message.init(
                                  true, _textEditingController.text);

                              _messageList.add(message);
                            }

                            scrollToNewChild();
                            _textEditingController.clear();
                          },
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
