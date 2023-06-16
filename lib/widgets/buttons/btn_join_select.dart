import 'package:flutter/material.dart';
import 'package:random_word_chat/utils/constants/custom_color.dart';

class BtnJoinSelect extends StatelessWidget {
  final String title;
  final Function(BuildContext) onPressed;

  const BtnJoinSelect(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed(context);
      },
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(80, 35),
          backgroundColor: CustomColor.violet,
          foregroundColor: CustomColor.white,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Text(
        title,
        style: const TextStyle(fontFamily: "suit_heavy", fontSize: 12),
      ),
    );
  }
}
