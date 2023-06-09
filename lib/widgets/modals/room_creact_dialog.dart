import 'package:flutter/material.dart';

import '../buttons/btn_join_select.dart';
import '../inputs/input_room.dart';

class RoomCreateDialog extends StatelessWidget {
  final String title;
  final String title1;
  final String title2;
  final String btnText;
  final TextEditingController roomController;
  final TextEditingController nameController;
  final Function(BuildContext) onSubmit;

  const RoomCreateDialog(
      {super.key,
      required this.title,
      required this.title1,
      required this.title2,
      required this.btnText,
      required this.roomController,
      required this.nameController,
      required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: SizedBox(
          height: 240,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(fontFamily: "suit_heavy", fontSize: 16),
                  ),
                  InputRoom(
                      title: title1, textEditingController: roomController),
                  InputRoom(
                      title: title2, textEditingController: nameController),
                  BtnJoinSelect(title: btnText, onPressed: onSubmit)
                ]),
          ),
        ));
  }
}
