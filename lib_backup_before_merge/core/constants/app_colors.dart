import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF5B5FEF);
const Color kPrimaryDark = Color(0xFF3F46C8);
const Color kAccent = Color(0xFF7C4DFF);
const Color kSurface = Color(0xFFF7F8FC);
const Color kText = Color(0xFF15162A);
const Color kMuted = Color(0xFF6B7280);

const Color kNavy = Color(0xFF050817);
const Color kPanel = Color(0xFF0B1230);
const Color kPanel2 = Color(0xFF101A3D);
const Color kLine = Color(0xFF203064);
const Color kPurple = Color(0xFF7C5CFF);
const Color kBlue = Color(0xFF20A8FF);
const Color kCyan = Color(0xFF19E6E0);
const Color kOrange = Color(0xFFFFB52E);
const Color kPink = Color(0xFFFF4FD8);
const Color kGreen = Color(0xFF35E6A1);
const Color kWhite = Color(0xFFF5F7FF);
const Color kSoft = Color(0xFFA8B5D8);

BoxDecoration appCardDecoration({double radius = 24}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: const Color(0xFFE8EAF4)),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF2F3573).withOpacity(0.07),
        blurRadius: 24,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

LinearGradient get appGradient => const LinearGradient(
  colors: [kPrimaryDark, kPrimary, kAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
