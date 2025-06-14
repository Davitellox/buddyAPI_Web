import 'package:buddy/pages/_logik/components/theme_colors.dart';
import 'package:flutter/material.dart';

class SmalltileCustom extends StatelessWidget {
  final String imgPath;
  final String userType;
  final bool apple;

  const SmalltileCustom(
      {super.key, required this.imgPath, required this.userType, required this.apple});

  @override
  Widget build(BuildContext context) {
    final theme = getThemeColors(userType);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.fieldFillColor,
        border: Border.all(color: theme.borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(
        imgPath,
        height: 40,
        color: apple ? Colors.white : null,
      ),
    );
  }
}
