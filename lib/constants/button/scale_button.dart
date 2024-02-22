import 'package:flutter/material.dart';
import 'package:home_workout/constants/colors/app_color.dart';

class Scale_button extends StatelessWidget {
  final VoidCallback onTap;

  Scale_button({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Ink(
            width: 200,
            decoration: BoxDecoration(
              color: AppColor.blueColor,
              borderRadius: BorderRadius.circular(230),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 24),
              child: Center(
                child: Text(
                  'Watch Video',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
