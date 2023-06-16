import 'package:flutter/material.dart';

class RegisteredRoom extends StatelessWidget {
  final String testRoomName;

  const RegisteredRoom({super.key, required this.testRoomName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("방 클릭");
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
                          Text(
                            testRoomName,
                            style: const TextStyle(
                                fontFamily: "suit_heavy", fontSize: 16),
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
