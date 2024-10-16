import 'package:flutter/material.dart';
import 'package:positio_test/src/themes/themes.dart';
import 'package:sizer/sizer.dart';


class CancelButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final double? height;
  final double? fontSize;

  const CancelButton(
      this.title, {super.key,
        required this.onPressed,
        this.height,
        this.fontSize,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 12.w,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
            side: BorderSide(color: appColorPrimary),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize ?? 12.sp,
            color: appColorPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}