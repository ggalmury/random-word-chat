import 'package:flutter/material.dart';
import 'package:random_word_chat/widgets/boxes/speech_bubble.dart';
import '../../models/internal/message.dart';

class OtherMessage extends StatelessWidget {
  final Message meta;
  final bool isMyMessage;

  const OtherMessage(
      {super.key, required this.meta, required this.isMyMessage});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(meta.sender),
        SpeechBubble(meta: meta, isMyMessage: isMyMessage)
      ])
    ]);
  }
}
