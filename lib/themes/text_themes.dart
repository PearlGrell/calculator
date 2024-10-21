import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(BuildContext context, String bodyFont, String displayFont){
  return TextTheme(
    displayLarge: GoogleFonts.getFont(displayFont, fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    displayMedium: GoogleFonts.getFont(displayFont, fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    displaySmall: GoogleFonts.getFont(displayFont, fontSize: 48, fontWeight: FontWeight.w400),
    headlineLarge: GoogleFonts.getFont(displayFont, fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headlineMedium: GoogleFonts.getFont(displayFont, fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headlineSmall: GoogleFonts.getFont(displayFont, fontSize: 24, fontWeight: FontWeight.w400),
    titleLarge: GoogleFonts.getFont(displayFont, fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleMedium: GoogleFonts.getFont(bodyFont, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    titleSmall: GoogleFonts.getFont(bodyFont, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge: GoogleFonts.getFont(bodyFont, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: GoogleFonts.getFont(bodyFont, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    bodySmall: GoogleFonts.getFont(bodyFont, fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: GoogleFonts.getFont(bodyFont, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    labelMedium: GoogleFonts.getFont(bodyFont, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1),
    labelSmall: GoogleFonts.getFont(bodyFont, fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  );
}