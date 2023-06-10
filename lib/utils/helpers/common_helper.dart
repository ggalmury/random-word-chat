import 'package:flutter/material.dart';

class CommonHelper {
  static void showSnackBar(BuildContext context, String text,
      {String? fontFamily,
      double? fontSize,
      int? duration,
      SnackBarBehavior? behavior}) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(
          text,
          style: TextStyle(
              fontFamily: fontFamily ?? "pretendard_medium",
              fontSize: fontSize ?? 14),
        ),
      ),
      duration: Duration(milliseconds: duration ?? 2000),
      behavior: behavior ?? SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
