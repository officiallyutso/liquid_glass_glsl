import 'package:flutter/material.dart';

/// config for liquid glass
class LiquidGlassConfig {
  ///backgiound brlur
  final double blurSigma;
  
  ///distortion intensity
  final double distortionIntensity;
  
  ///animmaion speed multiplier (0.1 to 5.0)
  final double animationSpeed;
  
  final Color glassColor;
  final bool useBackdrop;
  final bool enableTouchRipples;
  
  ///ripple radius
  final double touchRippleRadius;
  final BorderRadius? borderRadius;
  
  const LiquidGlassConfig({
    this.blurSigma = 20.0,
    this.distortionIntensity = 0.04,
    this.animationSpeed = 1.5,
    this.glassColor = Colors.white54,
    this.useBackdrop = true,
    this.enableTouchRipples = false,
    this.touchRippleRadius = 0.1,
    this.borderRadius,
  });
  
  /// makesd a copy of this config with some properties replaced
  LiquidGlassConfig copyWith({
    double? blurSigma,
    double? distortionIntensity,
    double? animationSpeed,
    Color? glassColor,
    bool? useBackdrop,
    bool? enableTouchRipples,
    double? touchRippleRadius,
    BorderRadius? borderRadius,
  }) {
    return LiquidGlassConfig(
      blurSigma: blurSigma ?? this.blurSigma,
      distortionIntensity: distortionIntensity ?? this.distortionIntensity,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      glassColor: glassColor ?? this.glassColor,
      useBackdrop: useBackdrop ?? this.useBackdrop,
      enableTouchRipples: enableTouchRipples ?? this.enableTouchRipples,
      touchRippleRadius: touchRippleRadius ?? this.touchRippleRadius,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}

/// Predefined glass effect presets
class LiquidGlassPresets {
  static const LiquidGlassConfig subtle = LiquidGlassConfig(
    blurSigma: 15.0,
    distortionIntensity: 0.02,
    animationSpeed: 1.0,
    glassColor: Colors.white38,
  );
  
  static const LiquidGlassConfig intense = LiquidGlassConfig(
    blurSigma: 25.0,
    distortionIntensity: 0.06,
    animationSpeed: 2.0,
    glassColor: Colors.white60,
  );
  
  static const LiquidGlassConfig minimal = LiquidGlassConfig(
    blurSigma: 10.0,
    distortionIntensity: 0.01,
    animationSpeed: 0.8,
    glassColor: Colors.white24,
  );
  
  static const LiquidGlassConfig interactive = LiquidGlassConfig(
    blurSigma: 20.0,
    distortionIntensity: 0.04,
    animationSpeed: 1.5,
    glassColor: Colors.white54,
    enableTouchRipples: true,
    touchRippleRadius: 0.15,
  );
}
