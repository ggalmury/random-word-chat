import 'package:flutter/material.dart';
import 'package:random_word_chat/widgets/boxes/speech_bubble.dart';
import '../../models/message.dart';

class OtherMessage extends StatelessWidget {
  final Message meta;
  final String currentUser;

  const OtherMessage(
      {super.key, required this.meta, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
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
        SpeechBubble(meta: meta, currentUser: currentUser)
      ])
    ]);
  }
}
