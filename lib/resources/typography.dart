import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTypography {
  const AppTypography._();

  static TextStyle b30 = GoogleFonts.ubuntu(
    fontSize: 30,
    fontWeight: FontWeight.w700,
  );

  static TextStyle b25 = GoogleFonts.ubuntu(
    fontSize: 25,
    fontWeight: FontWeight.w700,
  );

  static TextStyle m25 = GoogleFonts.ubuntu(
    fontSize: 25,
    fontWeight: FontWeight.w500,
  );

  static TextStyle b20 = GoogleFonts.ubuntu(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static TextStyle m20 = GoogleFonts.ubuntu(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle m18 = GoogleFonts.ubuntu(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle m16 = GoogleFonts.ubuntu(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle m14 = GoogleFonts.ubuntu(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle r14 = GoogleFonts.ubuntu(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
