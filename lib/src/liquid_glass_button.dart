import 'package:flutter/material.dart';
import 'liquid_glass_widget.dart';
import 'config.dart';

/// A button widget with liquid glass effect
class LiquidGlassButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double blurSigma;
  final double distortionIntensity;
  final double animationSpeed;
  final Color glassColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Size? minimumSize;
  
  ///enable backdrop blur
  final bool useBackdrop;
  
  const LiquidGlassButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.blurSigma = 18.0,
    this.distortionIntensity = 0.03,
    this.animationSpeed = 1.2,
    this.glassColor = Colors.white38,
    this.borderRadius,
    this.padding,
    this.margin,
    this.minimumSize,
    this.useBackdrop = true,
  }) : super(key: key);
  
  @override
  State<LiquidGlassButton> createState() => _LiquidGlassButtonState();
}

class _LiquidGlassButtonState extends State<LiquidGlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _distortionAnimation;
  
  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
    
    _distortionAnimation = Tween<double>(
      begin: widget.distortionIntensity,
      end: widget.distortionIntensity * 1.5,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
  }
  
  void _handleTapDown(TapDownDetails details) {
    _pressController.forward();
  }
  
  void _handleTapUp(TapUpDetails details) {
    _pressController.reverse();
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }
  
  void _handleTapCancel() {
    _pressController.reverse();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: LiquidGlassGLSL(
              padding: widget.padding ?? const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              margin: widget.margin,
              config: LiquidGlassConfig(
                blurSigma: widget.blurSigma,
                distortionIntensity: _distortionAnimation.value,
                animationSpeed: widget.animationSpeed,
                glassColor: widget.glassColor,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12.0),
                useBackdrop: widget.useBackdrop,
                enableTouchRipples: true,
              ),
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }
}
