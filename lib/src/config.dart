import 'package:flutter/material.dart';

/// config for liquid glass
class LiquidGlassConfig {
  ///backgiound brlur
  final double blurSigma;
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
    required this.blurSigma,
    required this.distortionIntensity,
    required this.animationSpeed,
    required this.glassColor,
    required this.useBackdrop,
    required this.enableTouchRipples,
    required this.touchRippleRadius,
    this.borderRadius,
  });

  //factory constructor with default values
  factory LiquidGlassConfig.defaultConfig() {
    return const LiquidGlassConfig(
      blurSigma: 20.0,
      distortionIntensity: 0.04,
      animationSpeed: 1.5,
      glassColor: Color(0x8AFFFFFF),
      useBackdrop: true,
      enableTouchRipples: false,
      touchRippleRadius: 0.1,
      borderRadius: null,
    );
  }

  //factory constructor for custom configuration
  factory LiquidGlassConfig.custom({
    double? blurSigma,
    double? distortionIntensity,
    double? animationSpeed,
    Color? glassColor,
    bool? useBackdrop,
    bool? enableTouchRipples,
    double? touchRippleRadius,
    BorderRadius? borderRadius,
  }) {
    final defaults = LiquidGlassConfig.defaultConfig();
    return LiquidGlassConfig(
      blurSigma: blurSigma ?? defaults.blurSigma,
      distortionIntensity: distortionIntensity ?? defaults.distortionIntensity,
      animationSpeed: animationSpeed ?? defaults.animationSpeed,
      glassColor: glassColor ?? defaults.glassColor,
      useBackdrop: useBackdrop ?? defaults.useBackdrop,
      enableTouchRipples: enableTouchRipples ?? defaults.enableTouchRipples,
      touchRippleRadius: touchRippleRadius ?? defaults.touchRippleRadius,
      borderRadius: borderRadius ?? defaults.borderRadius,
    );
  }
  
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
    glassColor: Color(0x61FFFFFF),
    useBackdrop: true,
    enableTouchRipples: false,
    touchRippleRadius: 0.1,
  );
  
  static const LiquidGlassConfig intense = LiquidGlassConfig(
    blurSigma: 25.0,
    distortionIntensity: 0.06,
    animationSpeed: 2.0,
    glassColor: Color(0x99FFFFFF),
    useBackdrop: true,
    enableTouchRipples: false,
    touchRippleRadius: 0.1,
  );
  
  static const LiquidGlassConfig minimal = LiquidGlassConfig(
    blurSigma: 10.0,
    distortionIntensity: 0.01,
    animationSpeed: 0.8,
    glassColor: Color(0x3DFFFFFF),
    useBackdrop: true,
    enableTouchRipples: false,
    touchRippleRadius: 0.1,
  );
  
  static const LiquidGlassConfig interactive = LiquidGlassConfig(
    blurSigma: 20.0,
    distortionIntensity: 0.04,
    animationSpeed: 1.5,
    glassColor: Color(0x8AFFFFFF),
    useBackdrop: true,
    enableTouchRipples: true,
    touchRippleRadius: 0.15,
  );
}
