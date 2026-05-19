import 'package:flutter/material.dart';
import '../../core/theme/cosmic_theme.dart';

class DeviceFrame extends StatelessWidget {
  final Widget child;
  final String deviceType; // 'iOS' or 'Android'
  final Color themeColor;
  final double? width;
  final double? height;

  const DeviceFrame({
    super.key,
    required this.child,
    required this.deviceType,
    this.themeColor = CosmicTheme.primaryPurple,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    bool isIos = deviceType == 'iOS';

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate appropriate scale sizing to fit the frame in constraints
        double frameWidth = width ?? 310.0;
        double frameHeight = height ?? 620.0;

        return Center(
          child: Container(
            width: frameWidth,
            height: frameHeight,
            padding: const EdgeInsets.all(12), // Outer Bezel Size
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D18), // Deep bezel metallic matte dark
              borderRadius: BorderRadius.circular(isIos ? 48 : 36),
              border: Border.all(
                color: themeColor.withOpacity(0.4),
                width: 3.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: themeColor.withOpacity(0.12),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main screen inside the device bezels
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(isIos ? 38 : 28),
                    child: Container(
                      color: CosmicTheme.spaceBlack,
                      child: child,
                    ),
                  ),
                ),

                // Side Buttons - Mock Volume Up/Down (left) & Power (right)
                // Volume Up
                Positioned(
                  left: -16,
                  top: 150,
                  child: _buildSideButton(height: 50, isLeft: true),
                ),
                // Volume Down
                Positioned(
                  left: -16,
                  top: 215,
                  child: _buildSideButton(height: 50, isLeft: true),
                ),
                // Power Button
                Positioned(
                  right: -16,
                  top: 180,
                  child: _buildSideButton(height: 75, isLeft: false),
                ),

                // TOP CAMERA / SENSORS (Dynamic Island vs Punch Hole)
                if (isIos)
                  // Sleek Dynamic Island Notch
                  Positioned(
                    top: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 105,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.04),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Left sensor lens
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0F0B24),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 48),
                            // Right camera lens with subtle purple glow reflection
                            Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF2C194D),
                                    Colors.black,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 3,
                                  height: 3,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00C3FF),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  // Minimalist Samsung Android Punch Hole
                  Positioned(
                    top: 14,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.06),
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Color(0xFF161E54),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Bottom Home Bar Indicator (iOS style only)
                if (isIos)
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 110,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSideButton({required double height, required bool isLeft}) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B2C),
        borderRadius: BorderRadius.only(
          topLeft: isLeft ? const Radius.circular(3) : Radius.zero,
          bottomLeft: isLeft ? const Radius.circular(3) : Radius.zero,
          topRight: !isLeft ? const Radius.circular(3) : Radius.zero,
          bottomRight: !isLeft ? const Radius.circular(3) : Radius.zero,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 2,
            offset: Offset(isLeft ? -1 : 1, 1),
          ),
        ],
      ),
    );
  }
}
