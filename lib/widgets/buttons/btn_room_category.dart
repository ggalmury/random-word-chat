import 'package:flutter/material.dart';
import 'package:random_word_chat/utils/constants/custom_color.dart';

class BtnRoomCategory extends StatelessWidget {
  final String title;

  const BtnRoomCategory({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(80, 30),
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            side: const BorderSide(color: CustomColor.grey, width: 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Text(
          title,
          style: const TextStyle(
              fontFamily: "pretendard_medium",
              fontSize: 12,
              color: Colors.black87),
        ));
  }
}
