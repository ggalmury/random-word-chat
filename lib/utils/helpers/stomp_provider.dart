import 'dart:convert';
import 'package:random_word_chat/bloc/room_bloc.dart';
import 'package:random_word_chat/main.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../../bloc/last_message_bloc.dart';
import '../../models/external/message_dto.dart';
import '../../models/internal/room.dart';

class StompProvider {
  static final StompProvider _instance = StompProvider._internal();
  late final StompClient stompClient;
  late final RoomBloc roomBloc;
  late final LastMessageBloc lastMessageBloc;

  StompProvider._internal();

  factory StompProvider() {
    return _instance;
  }

  void injectBloc(RoomBloc roomBloc, LastMessageBloc lastMessageBloc) {
    _instance.roomBloc = roomBloc;
    _instance.lastMessageBloc = lastMessageBloc;
  }

  Future<void> connectToChatServer() async {
    stompClient = StompClient(
        config: StompConfig.SockJS(
            url: "http://43.200.100.168:8080/chat",
            onConnect: _onConnect,
            onWebSocketError: _onWebSocketError));

    await Future.delayed(const Duration(milliseconds: 300));
    stompClient.activate();
    loggerNoStack.i("stomp client connected!");
  }

  void _onConnect(StompFrame stompFrame) {
    List<Room> roomList = roomBloc.state.roomList;

    for (var room in roomList) {
      stompClient.subscribe(
          destination: '/sub/chat/room/${room.roomId}', callback: _onMessage);
    }
  }

  void _onWebSocketError(dynamic error) {
    loggerNoStack.e(error);
  }

  void _onMessage(StompFrame stompFrame) {
    if (stompFrame.body != null) {
      final jsonMessage = jsonDecode(stompFrame.body!);
      final chatMessage = MessageDto.fromJson(jsonMessage);

      lastMessageBloc.add(UpdateLastMessageEvent(messageDto: chatMessage));
    }
  }

  void emitMessage(MessageDto messageDto) {
    stompClient.send(
        destination: '/pub/chat/message', body: jsonEncode(messageDto));
  }
}
