import 'package:flutter/material.dart';

class CosmicTheme {
  // Deep Space Color Palette
  static const Color spaceBlack = Color(0xFF03030A);
  static const Color nebulaDark = Color(0xFF080718);
  static const Color cosmicNavy = Color(0xFF0D0C27);
  static const Color glassWhite = Color(0x06FFFFFF);
  
  // Neon Electric Accents
  static const Color primaryPurple = Color(0xFF8B2CF5);
  static const Color neonCyan = Color(0xFF00FFD2);
  static const Color cyberPink = Color(0xFFFE0E85);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color electricBlue = Color(0xFF1852FF);

  // Background Nebula Gradients
  static const Gradient spaceGradient = LinearGradient(
    colors: [spaceBlack, nebulaDark, cosmicNavy],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient purpleGlowGradient = LinearGradient(
    colors: [primaryPurple, Color(0xFFBD00FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient cyanGlowGradient = LinearGradient(
    colors: [neonCyan, electricBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Custom Neon Drop Shadows for glowing components
  static List<BoxShadow> neonGlow({required Color color, double blur = 15, double spread = 1}) {
    return [
      BoxShadow(
        color: color.withOpacity(0.35),
        blurRadius: blur,
        spreadRadius: spread,
      ),
      BoxShadow(
        color: color.withOpacity(0.1),
        blurRadius: blur * 2,
        spreadRadius: spread + 1,
      ),
    ];
  }

  // Box border styling representing premium cosmic glass panels
  static Border glassBorder({required Color accentColor, double opacity = 0.2}) {
    return Border.all(
      color: accentColor.withOpacity(opacity),
      width: 1.2,
    );
  }

  // Rounded Corner Decos
  static BorderRadius cardRadius = BorderRadius.circular(16);
  static BorderRadius windowRadius = BorderRadius.circular(20);
}
