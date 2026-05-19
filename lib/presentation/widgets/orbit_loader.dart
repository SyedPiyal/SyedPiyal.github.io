import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/cosmic_theme.dart';

class OrbitLoader extends StatefulWidget {
  final VoidCallback onLoaded;

  const OrbitLoader({super.key, required this.onLoaded});

  @override
  State<OrbitLoader> createState() => _OrbitLoaderState();
}

class _OrbitLoaderState extends State<OrbitLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _loadingProgress = 0.0;
  String _loadingText = 'INITIALIZING COSMIC SYSTEM...';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _simulateLoading();
  }

  void _simulateLoading() async {
    List<String> logs = [
      'INITIALIZING COSMIC SYSTEM...',
      'LOADING DYNAMIC NEBULAS...',
      'CALIBRATING RETRO arcade FRAME...',
      'RENDERING CONCENTRIC PLANETARY ORBITS...',
      'BOOTSTRAPPING SYED\'S PORTFOLIO OS...',
      'SYSTEM READY.',
    ];

    for (int i = 0; i < logs.length; i++) {
      await Future.delayed(Duration(milliseconds: i == logs.length - 1 ? 500 : 700));
      if (!mounted) return;
      setState(() {
        _loadingText = logs[i];
        _loadingProgress = (i + 1) / logs.length;
      });
    }

    // Call onLoaded after a short final delay
    await Future.delayed(const Duration(milliseconds: 300));
    widget.onLoaded();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmicTheme.spaceBlack,
      body: Stack(
        children: [
          // Background space mesh
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: CosmicTheme.spaceGradient,
              ),
            ),
          ),
          
          // Concentric loader itself
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return SizedBox(
                      width: 250,
                      height: 250,
                      child: CustomPaint(
                        painter: OrbitPainter(
                          rotationAngle: _controller.value * 2 * pi,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
                
                // Syed Branding Header
                Text(
                  'SYED',
                  style: GoogleFonts.orbitron(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    color: Colors.white,
                    shadows: CosmicTheme.neonGlow(color: CosmicTheme.primaryPurple, blur: 10),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Loading Log
                SizedBox(
                  height: 20,
                  child: Text(
                    _loadingText,
                    style: GoogleFonts.shareTechMono(
                      color: CosmicTheme.neonCyan,
                      fontSize: 12,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Custom loading progress bar
                Container(
                  width: 220,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 220 * _loadingProgress,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [CosmicTheme.primaryPurple, CosmicTheme.neonCyan],
                          ),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: CosmicTheme.neonGlow(color: CosmicTheme.neonCyan, blur: 5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrbitPainter extends CustomPainter {
  final double rotationAngle;

  OrbitPainter({required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 1. Draw Orbits (Faint Circles)
    final List<double> orbitRadii = [50.0, 85.0, 120.0];
    final List<Color> orbitColors = [
      CosmicTheme.cyberPink.withOpacity(0.15),
      CosmicTheme.primaryPurple.withOpacity(0.15),
      CosmicTheme.neonCyan.withOpacity(0.15),
    ];

    for (int i = 0; i < orbitRadii.length; i++) {
      paint.color = orbitColors[i];
      canvas.drawCircle(center, orbitRadii[i], paint);
    }

    // 2. Draw Sun (Central Star)
    final sunPaint = Paint()
      ..color = const Color(0xFFFF9E00)
      ..style = PaintingStyle.fill;
    
    // Draw Sun glow
    final sunGlowPaint = Paint()
      ..color = const Color(0xFFFF9E00).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 22, sunGlowPaint);
    canvas.drawCircle(center, 12, sunPaint);

    // 3. Draw Revolving Planets
    final List<double> planetSizes = [6.0, 9.0, 12.0];
    final List<Color> planetColors = [
      CosmicTheme.cyberPink,
      CosmicTheme.primaryPurple,
      CosmicTheme.neonCyan,
    ];
    // Different speeds: inner orbits rotate faster, outer orbits slower
    final List<double> planetSpeeds = [2.2, 1.2, 0.7];
    // Start phases
    final List<double> planetPhases = [0.0, pi * 0.5, pi * 1.2];

    for (int i = 0; i < orbitRadii.length; i++) {
      final double angle = rotationAngle * planetSpeeds[i] + planetPhases[i];
      final double planetX = center.dx + orbitRadii[i] * cos(angle);
      final double planetY = center.dy + orbitRadii[i] * sin(angle);
      final planetOffset = Offset(planetX, planetY);

      // Draw Planet Glow
      final planetGlowPaint = Paint()
        ..color = planetColors[i].withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(planetOffset, planetSizes[i] * 1.8, planetGlowPaint);

      // Draw Planet Body
      final planetPaint = Paint()
        ..color = planetColors[i]
        ..style = PaintingStyle.fill;
      canvas.drawCircle(planetOffset, planetSizes[i], planetPaint);

      // Faint trail behind planet
      final trailPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = planetColors[i].withOpacity(0.08);
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: orbitRadii[i]),
        angle - pi * 0.4,
        pi * 0.4,
        false,
        trailPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
