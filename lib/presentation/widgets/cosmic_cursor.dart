import 'package:flutter/material.dart';
import '../../core/theme/cosmic_theme.dart';
import '../state/portfolio_notifier.dart';

class CosmicCursor extends StatefulWidget {
  final Widget child;
  final PortfolioNotifier notifier;

  const CosmicCursor({
    super.key,
    required this.child,
    required this.notifier,
  });

  @override
  State<CosmicCursor> createState() => _CosmicCursorState();
}

class _CosmicCursorState extends State<CosmicCursor> {
  Offset _mousePos = Offset.zero;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.notifier,
      builder: (context, child) {
        // On mobile emulators or small screens, disable custom cursor to avoid finger-drag redundancy
        double screenWidth = MediaQuery.of(context).size.width;
        if (screenWidth < 900) {
          return widget.child;
        }

        return MouseRegion(
          cursor: SystemMouseCursors.none, // Hide default system cursor
          onHover: (event) {
            setState(() {
              _mousePos = event.localPosition;
              _visible = true;
            });
          },
          onExit: (_) {
            setState(() {
              _visible = false;
            });
          },
          child: Stack(
            children: [
              // 1. The original page contents
              widget.child,

              // 2. The Custom Cosmic Cursor follower layers (Only if visible)
              if (_visible) ...[
                // OUTER CONCENTRIC RING: smoothly lags behind with AnimatedPositioned
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOutCubic,
                  // Center the outer container over _mousePos
                  left: _mousePos.dx - (widget.notifier.isHoveringInteractive ? 28 : 16),
                  top: _mousePos.dy - (widget.notifier.isHoveringInteractive ? 28 : 16),
                  child: IgnorePointer(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      width: widget.notifier.isHoveringInteractive ? 56 : 32,
                      height: widget.notifier.isHoveringInteractive ? 56 : 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.notifier.isHoveringInteractive
                            ? CosmicTheme.cyberPink.withOpacity(0.12)
                            : Colors.transparent,
                        border: Border.all(
                          color: widget.notifier.isHoveringInteractive
                              ? CosmicTheme.cyberPink
                              : CosmicTheme.neonCyan.withOpacity(0.6),
                          width: widget.notifier.isHoveringInteractive ? 1.5 : 1.0,
                        ),
                        boxShadow: widget.notifier.isHoveringInteractive
                            ? CosmicTheme.neonGlow(color: CosmicTheme.cyberPink, blur: 12)
                            : CosmicTheme.neonGlow(color: Colors.transparent, blur: 0, spread: 0),
                      ),
                    ),
                  ),
                ),

                // INNER CONCENTRIC DOT: instant coordinates tracking
                Positioned(
                  left: _mousePos.dx - 3,
                  top: _mousePos.dy - 3,
                  child: IgnorePointer(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.notifier.isHoveringInteractive
                            ? CosmicTheme.cyberPink
                            : CosmicTheme.neonCyan,
                        boxShadow: CosmicTheme.neonGlow(
                          color: widget.notifier.isHoveringInteractive
                              ? CosmicTheme.cyberPink
                              : CosmicTheme.neonCyan,
                          blur: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
