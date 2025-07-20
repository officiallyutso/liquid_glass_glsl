import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class LiquidGlassUtils {
  static ui.FragmentShader? _cachedShader;
  
  /// Loads and caches the liquid glass fragment shader
  static Future<ui.FragmentShader> loadShader() async {
    if (_cachedShader != null) {
      return _cachedShader!;
    }
    
    final program = await ui.FragmentProgram.fromAsset('shaders/liquid_glass.frag');
    _cachedShader = program.fragmentShader();
    return _cachedShader!;
  }
  
  ///dispose krdo sab brooo
  static void dispose() {
    _cachedShader?.dispose();
    _cachedShader = null;
  }
}

///custom ticker provider for shader animations and scheduler
class ShaderTickerProvider extends TickerProvider {
  final List<Ticker> _tickers = <Ticker>[];
  
  @override
  Ticker createTicker(TickerCallback onTick) {
    final ticker = Ticker(onTick);
    _tickers.add(ticker);
    return ticker;
  }
  
  void dispose() {
    for (final ticker in _tickers) {
      ticker.dispose();
    }
    _tickers.clear();
  }
}

///utility funct8ion for glass effect calculations
class GlassEffectUtils {
  /// Calculates optimal blur sigma based on widget size
  static double calculateOptimalBlur(Size size) {
    final area = size.width * size.height;
    return (area / 10000).clamp(5.0, 30.0);
  }
  
  ///touched position ko normalized coordinates pe convert kro
  static Offset normalizePosition(Offset position, Size size) {
    return Offset(
      position.dx / size.width,
      position.dy / size.height,
    );
  }
  
  ///distortion inbtensity do as you please okieee 
  static double calculateDistortion(double progress, double baseIntensity) {
    return baseIntensity * (1.0 + 0.2 * progress);
  }
}
