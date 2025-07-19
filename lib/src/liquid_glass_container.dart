import 'package:flutter/material.dart';
import 'liquid_glass_widget.dart';
import 'config.dart';

/// A container widget with liquid glass effect
class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double blurSigma;
  final double distortionIntensity;
  final double animationSpeed;
  final Color glassColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool useBackdrop;
  
  ///enablef touch ripple effects
  final bool enableTouchRipples;
  
  const LiquidGlassContainer({
    Key? key,
    required this.child,
    this.width,
    // this.animationSpeed = 2.3,
    // this.blurSigma = 10.0,
    // this.fun,
    this.height,
    this.blurSigma = 20.0,
    this.distortionIntensity = 0.04,
    this.animationSpeed = 1.5,
    this.glassColor = const Color(0x8AFFFFFF),
    this.borderRadius,
    this.padding,
    this.margin,
    this.useBackdrop = true,
    this.enableTouchRipples = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LiquidGlassGLSL(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      config: LiquidGlassConfig(
        blurSigma: blurSigma,
        distortionIntensity: distortionIntensity,
        animationSpeed: animationSpeed,
        glassColor: glassColor,
        borderRadius: borderRadius,
        useBackdrop: useBackdrop,
        enableTouchRipples: enableTouchRipples,
        touchRippleRadius: 0.1,
      ),
      child: child,
    );
  }
}
