import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_word_chat/utils/constants/custom_color.dart';
import '../../models/message.dart';

class SpeechBubble extends StatelessWidget {
  final Message meta;
  final bool isMyMessage;

  const SpeechBubble(
      {super.key, required this.meta, required this.isMyMessage});

  List<Widget> _widgets() {
    DateFormat dateFormat = DateFormat("HH:mm");

    return [
      Text(dateFormat.format(meta.time ?? DateTime.now()),
          style: const TextStyle(fontSize: 12)),
      const SizedBox(width: 10),
      Container(
          constraints: const BoxConstraints(
            maxWidth: 210,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMyMessage ? 15 : 0),
                  topRight: const Radius.circular(15),
                  bottomLeft: const Radius.circular(15),
                  bottomRight: Radius.circular(isMyMessage ? 0 : 15)),
              color: isMyMessage ? CustomColor.violet : Colors.white70),
          padding: const EdgeInsets.all(12),
          child: Text(meta.message,
              style: TextStyle(
                  color: isMyMessage ? CustomColor.white : Colors.black,
                  fontFamily: "pretendard_medium")))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: isMyMessage ? _widgets() : _widgets().reversed.toList()));
  }
}
