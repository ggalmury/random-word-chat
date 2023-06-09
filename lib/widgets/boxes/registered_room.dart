import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_word_chat/bloc/last_message_bloc.dart';
import '../../models/internal/room.dart';
import '../../screens/chatroom.dart';
import '../../utils/helpers/common_helper.dart';

class RegisteredRoom extends StatelessWidget {
  final Room room;

  const RegisteredRoom({super.key, required this.room});

  bool _buildWhen(DefaultLastMessageState prev, DefaultLastMessageState curr) {
    return prev.lastMessage[room.roomId]?.message !=
        curr.lastMessage[room.roomId]?.message;
  }

  String _currentMessage(String? message) {
    return message ?? "";
  }

  String _currentTime(int? time) {
    return CommonHelper.formatDateTime(time) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonHelper.navigatePushHandler(context, ChatRoom(room: room));
      },
      child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(children: [
              Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.grey, shape: BoxShape.circle)),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              room.roomName ?? "새로운 방",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: "suit_heavy", fontSize: 16),
                            ),
                          ),
                          BlocBuilder<LastMessageBloc, DefaultLastMessageState>(
                            buildWhen: (previous, current) {
                              return _buildWhen(previous, current);
                            },
                            builder: (context, state) {
                              return Text(
                                  _currentTime(
                                      state.lastMessage[room.roomId]?.time),
                                  style: const TextStyle(
                                      fontFamily: "pretendard_medium",
                                      fontSize: 12));
                            },
                          )
                        ],
                      ),
                      BlocBuilder<LastMessageBloc, DefaultLastMessageState>(
                          buildWhen: (previous, current) {
                        return _buildWhen(previous, current);
                      }, builder: (context, state) {
                        return Text(
                            _currentMessage(
                                state.lastMessage[room.roomId]?.message),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12));
                      })
                    ]),
              ),
            ]),
          )),
    );
  }
}
