import 'package:flutter/material.dart';
import 'package:random_word_chat/utils/constants/custom_color.dart';

import '../../models/message.dart';

class ChatMessage extends StatelessWidget {
  final Message meta;
  final String currentUser;

  const ChatMessage({super.key, required this.meta, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Align(
        alignment: meta.sender == currentUser
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 250,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(meta.sender == currentUser ? 15 : 0),
              topRight: const Radius.circular(15),
              bottomLeft: const Radius.circular(15),
              bottomRight: Radius.circular(meta.sender == currentUser ? 0 : 15),
            ),
            color: meta.sender == currentUser
                ? CustomColor.violet
                : Colors.white70,
          ),
          padding: const EdgeInsets.all(12),
          child: Text(
            meta.message,
            style: TextStyle(
                color: meta.sender == currentUser
                    ? CustomColor.white
                    : Colors.black,
                fontFamily: "pretendard_medium"),
          ),
        ),
      ),
    );
  }
}
