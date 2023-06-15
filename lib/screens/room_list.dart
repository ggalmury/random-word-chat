import 'package:flutter/material.dart';
import 'package:random_word_chat/widgets/boxes/registered_room.dart';

class RoomList extends StatefulWidget {
  const RoomList({super.key});

  @override
  State<RoomList> createState() => _RoolListState();
}

class _RoolListState extends State<RoomList> {
  List<String> tempList = ["방1", "방2", "방3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("전체")),
                ElevatedButton(onPressed: () {}, child: Text("공개")),
                ElevatedButton(onPressed: () {}, child: Text("비공개"))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tempList.length,
              itemBuilder: (BuildContext context, int index) {
                return RegisteredRoom(testRoomName: tempList[index]);
              },
            ),
          )
        ],
      ),
    )));
  }
}
