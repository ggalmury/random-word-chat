import 'package:flutter/material.dart';
import '../../models/internal/room.dart';
import '../../screens/chatroom.dart';
import '../../utils/helpers/common_helper.dart';
import '../../utils/helpers/stomp_provider.dart';

class RegisteredRoom extends StatelessWidget {
  final Room room;

  const RegisteredRoom({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonHelper.navigatePushHandler(context,
            ChatRoom(room: room, stompClient: StompProvider().stompClient));
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
                          const Text("12:01",
                              style: TextStyle(
                                  fontFamily: "pretendard_medium",
                                  fontSize: 12))
                        ],
                      ),
                      const Text("채팅 내용", style: TextStyle(fontSize: 12))
                    ]),
              ),
            ]),
          )),
    );
  }
}
