import 'package:flutter/material.dart';

class InputRoom extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;

  const InputRoom(
      {super.key, required this.title, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: title,
          hintStyle:
              const TextStyle(fontFamily: "pretendard_medium", fontSize: 12)),
    );
  }
}
