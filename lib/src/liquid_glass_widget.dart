import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'config.dart';
import 'utils.dart';

/// Core liquid glass widget that applies shader effects to any child
class LiquidGlassGLSL extends StatefulWidget {
  /// The child widget to apply the glass effect to
  final Widget child;
  
  /// Configuration for the glass effect
  final LiquidGlassConfig config;
  
  /// Optional width constraint
  final double? width;
  
  /// Optional height constraint
  final double? height;
  
  /// Optional padding around the child
  final EdgeInsetsGeometry? padding;
  
  /// Optional margin around the glass container
  final EdgeInsetsGeometry? margin;
  
  const LiquidGlassGLSL({
    Key? key,
    required this.child,
    LiquidGlassConfig? config,
    this.width,
    this.height,
    this.padding,
    this.margin,
  }) : config = config ?? const LiquidGlassConfig(
         blurSigma: 20.0,
         distortionIntensity: 0.04,
         animationSpeed: 1.5,
         glassColor: Color(0x8AFFFFFF),
         useBackdrop: true,
         enableTouchRipples: false,
         touchRippleRadius: 0.1,
       ), super(key: key);
  
  /// Convenience constructor with individual parameters
  factory LiquidGlassGLSL.custom({
    Key? key,
    required Widget child,
    double? blurSigma,
    double? distortionIntensity,
    double? animationSpeed,
    Color? glassColor,
    bool? useBackdrop,
    bool? enableTouchRipples,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return LiquidGlassGLSL(
      key: key,
      child: child,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      config: LiquidGlassConfig.custom(
        blurSigma: blurSigma,
        distortionIntensity: distortionIntensity,
        animationSpeed: animationSpeed,
        glassColor: glassColor,
        useBackdrop: useBackdrop,
        enableTouchRipples: enableTouchRipples,
        borderRadius: borderRadius,
      ),
    );
  }

  @override
  State<LiquidGlassGLSL> createState() => _LiquidGlassGLSLState();
}

class _LiquidGlassGLSLState extends State<LiquidGlassGLSL>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  ui.FragmentShader? _shader;
  Offset? _lastTouchPosition;
  double _touchRadius = 0.0;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _loadShader();
  }
  
  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }
  
  Future<void> _loadShader() async {
    try {
      final shader = await LiquidGlassUtils.loadShader();
      if (mounted) {
        setState(() {
          _shader = shader;
        });
      }
    } catch (e) {
      debugPrint('Failed to load liquid glass shader: $e');
    }
  }
  
  void _handlePanStart(DragStartDetails details) {
    if (!widget.config.enableTouchRipples) return;
    
    setState(() {
      _lastTouchPosition = details.localPosition;
      _touchRadius = widget.config.touchRippleRadius;
    });
  }
  
  void _handlePanUpdate(DragUpdateDetails details) {
    if (!widget.config.enableTouchRipples) return;
    
    setState(() {
      _lastTouchPosition = details.localPosition;
    });
  }
  
  void _handlePanEnd(DragEndDetails details) {
    if (!widget.config.enableTouchRipples) return;
    
    setState(() {
      _touchRadius = 0.0;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
      child: widget.child,
    );
    
    if (_shader == null) {
      // Fallback while shader loads
      return Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: widget.config.glassColor,
          borderRadius: widget.config.borderRadius,
        ),
        child: ClipRRect(
          borderRadius: widget.config.borderRadius ?? BorderRadius.zero,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: widget.config.blurSigma,
              sigmaY: widget.config.blurSigma,
            ),
            child: content,
          ),
        ),
      );
    }
    
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint(
            painter: _LiquidGlassPainter(
              shader: _shader!,
              config: widget.config,
              time: _animationController.value,
              touchPosition: _lastTouchPosition,
              touchRadius: _touchRadius,
            ),
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: widget.margin,
              decoration: BoxDecoration(
                borderRadius: widget.config.borderRadius,
              ),
              child: ClipRRect(
                borderRadius: widget.config.borderRadius ?? BorderRadius.zero,
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: widget.config.useBackdrop ? widget.config.blurSigma : 0,
                    sigmaY: widget.config.useBackdrop ? widget.config.blurSigma : 0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.config.glassColor.withOpacity(0.1),
                      borderRadius: widget.config.borderRadius,
                    ),
                    child: content,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _LiquidGlassPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final LiquidGlassConfig config;
  final double time;
  final Offset? touchPosition;
  final double touchRadius;
  
  _LiquidGlassPainter({
    required this.shader,
    required this.config,
    required this.time,
    this.touchPosition,
    required this.touchRadius,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Set shader uniforms
    shader.setFloat(0, size.width);  // u_resolution.x
    shader.setFloat(1, size.height); // u_resolution.y
    shader.setFloat(2, time * 10);   // u_time
    shader.setFloat(3, config.distortionIntensity); // u_distortion_intensity
    shader.setFloat(4, config.animationSpeed);      // u_animation_speed
    
    // Touch interaction uniforms
    if (touchPosition != null && config.enableTouchRipples) {
      final normalizedTouch = GlassEffectUtils.normalizePosition(touchPosition!, size);
      shader.setFloat(5, normalizedTouch.dx); // u_touch_point.x
      shader.setFloat(6, normalizedTouch.dy); // u_touch_point.y
      shader.setFloat(7, touchRadius);        // u_touch_radius
    } else {
      shader.setFloat(5, -1.0); // u_touch_point.x (disabled)
      shader.setFloat(6, -1.0); // u_touch_point.y (disabled)
      shader.setFloat(7, 0.0);  // u_touch_radius (disabled)
    }
    
    // Create paint with shader
    final paint = Paint()..shader = shader;
    
    // Draw the shader effect
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant _LiquidGlassPainter oldDelegate) {
    return oldDelegate.time != time ||
           oldDelegate.touchPosition != touchPosition ||
           oldDelegate.touchRadius != touchRadius;
  }
}
