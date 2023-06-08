import 'package:flutter/material.dart';
import 'package:random_word_chat/utils/constants/custom_color.dart';

import '../../models/message.dart';

class ChatMessage extends StatelessWidget {
  final Message meta;

  const ChatMessage({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Align(
        alignment: meta.sender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 250,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomLeft: Radius.circular(meta.sender ? 15 : 0),
              bottomRight: Radius.circular(meta.sender ? 0 : 15),
            ),
            color: meta.sender ? CustomColor.violet : Colors.white70,
          ),
          padding: const EdgeInsets.all(12),
          child: Text(
            meta.message,
            style: TextStyle(
                color: meta.sender ? CustomColor.white : Colors.black,
                fontFamily: "pretendard_medium"),
          ),
        ),
      ),
    );
  }
}
