import 'package:flutter/material.dart';

class InputMessage extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;

  const InputMessage(
      {super.key,
      required this.textEditingController,
      required this.focusNode});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey, width: 2));

    return SizedBox(
      width: 300,
      child: TextField(
        focusNode: focusNode,
        controller: textEditingController,
        maxLines: null,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 14, fontFamily: "suit_heavy"),
        decoration: InputDecoration(
            border: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            contentPadding: const EdgeInsets.all(15)),
      ),
    );
  }
}
