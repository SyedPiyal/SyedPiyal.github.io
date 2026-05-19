import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/cosmic_theme.dart';

class CosmicBackground extends StatefulWidget {
  final Widget child;

  const CosmicBackground({super.key, required this.child});

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<StarParticle> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // Generate 60 static star positions with random speed, size, and depth
    for (int i = 0; i < 65; i++) {
      _stars.add(
        StarParticle(
          xPercent: _random.nextDouble(),
          yPercent: _random.nextDouble(),
          size: _random.nextDouble() * 2.2 + 0.5,
          speed: _random.nextDouble() * 0.015 + 0.005,
          color: _getRandomColor(),
          opacity: _random.nextDouble() * 0.6 + 0.3,
        ),
      );
    }
  }

  Color _getRandomColor() {
    double rand = _random.nextDouble();
    if (rand < 0.4) return Colors.white;
    if (rand < 0.7) return CosmicTheme.neonCyan;
    if (rand < 0.9) return CosmicTheme.primaryPurple;
    return CosmicTheme.cyberPink;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Increment star drift
        for (var star in _stars) {
          star.yPercent += star.speed * 0.05;
          if (star.yPercent > 1.0) {
            star.yPercent = 0.0;
            star.xPercent = _random.nextDouble();
          }
        }
        return CustomPaint(
          painter: SpacePainter(stars: _stars),
          child: widget.child,
        );
      },
    );
  }
}

class StarParticle {
  double xPercent;
  double yPercent;
  final double size;
  final double speed;
  final Color color;
  final double opacity;

  StarParticle({
    required this.xPercent,
    required this.yPercent,
    required this.size,
    required this.speed,
    required this.color,
    required this.opacity,
  });
}

class SpacePainter extends CustomPainter {
  final List<StarParticle> stars;

  SpacePainter({required this.stars});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // 1. Draw Deep cosmic space backdrop gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const gradient = RadialGradient(
      center: Alignment(0.3, -0.4),
      radius: 1.2,
      colors: [
        Color(0xFF0C0A25),
        Color(0xFF050512),
        Color(0xFF020206),
      ],
      stops: [0.0, 0.6, 1.0],
    );
    paint.shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
    paint.shader = null;

    // 2. Draw Soft Glowing Nebulae (large blurry circles in background)
    final nebulaPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120)
      ..style = PaintingStyle.fill;

    // Purple Nebula (Top Right)
    nebulaPaint.color = CosmicTheme.primaryPurple.withOpacity(0.08);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.25), size.width * 0.35, nebulaPaint);

    // Cyan Nebula (Bottom Left)
    nebulaPaint.color = CosmicTheme.neonCyan.withOpacity(0.06);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.75), size.width * 0.3, nebulaPaint);

    // Pink Nebula (Center)
    nebulaPaint.color = CosmicTheme.cyberPink.withOpacity(0.05);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.25, nebulaPaint);

    // 3. Draw Grid lines (futuristic coordinate mesh, barely visible)
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.015)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    double gridSpacing = 80.0;
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 4. Draw Stars
    for (var star in stars) {
      paint.color = star.color.withOpacity(star.opacity);
      
      // Draw subtle glow for larger stars
      if (star.size > 1.8) {
        final glowPaint = Paint()
          ..color = star.color.withOpacity(star.opacity * 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(
          Offset(star.xPercent * size.width, star.yPercent * size.height),
          star.size * 2.2,
          glowPaint,
        );
      }

      canvas.drawCircle(
        Offset(star.xPercent * size.width, star.yPercent * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
