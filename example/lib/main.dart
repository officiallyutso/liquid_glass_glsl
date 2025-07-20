import 'package:flutter/material.dart';
import 'package:liquid_glass_glsl/liquid_glass_glsl.dart';

void main() {
  runApp(const LiquidGlassDemo());
}

class LiquidGlassDemo extends StatelessWidget {
  const LiquidGlassDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Glass GLSL Demo',
      theme: ThemeData.dark(),
      home: const DemoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  LiquidGlassConfig _currentConfig = LiquidGlassPresets.subtle;
  String _selectedPreset = 'Subtle';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1a1a2e),
                  Color(0xFF16213e),
                  Color(0xFF0f3460),
                ],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Header
                  const Text(
                    'Liquid Glass GLSL',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Real-time shader-based glass effects',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Demo card
                  LiquidGlassContainer(
                    width: 350,
                    height: 200,
                    borderRadius: BorderRadius.circular(25),
                    blurSigma: _currentConfig.blurSigma,
                    distortionIntensity: _currentConfig.distortionIntensity,
                    animationSpeed: _currentConfig.animationSpeed,
                    glassColor: _currentConfig.glassColor,
                    enableTouchRipples: _currentConfig.enableTouchRipples,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 48,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Liquid Glass Effect',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Touch and interact with the surface',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LiquidGlassButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Primary action!')),
                          );
                        },
                        blurSigma: _currentConfig.blurSigma,
                        distortionIntensity: _currentConfig.distortionIntensity,
                        animationSpeed: _currentConfig.animationSpeed,
                        glassColor: const Color(0x4D2196F3), // Blue with opacity
                        child: const Text('Primary'),
                      ),
                      
                      LiquidGlassButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Secondary action!')),
                          );
                        },
                        blurSigma: _currentConfig.blurSigma,
                        distortionIntensity: _currentConfig.distortionIntensity,
                        animationSpeed: _currentConfig.animationSpeed,
                        glassColor: const Color(0x4D9C27B0), // Purple with opacity
                        child: const Text('Secondary'),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Controls
                  LiquidGlassContainer(
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(20),
                    padding: const EdgeInsets.all(20),
                    blurSigma: 15,
                    distortionIntensity: 0.02,
                    animationSpeed: 1.0,
                    glassColor: const Color(0x1AFFFFFF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Effect Presets',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        
                        Wrap(
                          spacing: 10,
                          children: [
                            _buildPresetChip('Subtle', LiquidGlassPresets.subtle),
                            _buildPresetChip('Intense', LiquidGlassPresets.intense),
                            _buildPresetChip('Minimal', LiquidGlassPresets.minimal),
                            _buildPresetChip('Interactive', LiquidGlassPresets.interactive),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPresetChip(String name, LiquidGlassConfig config) {
    final isSelected = _selectedPreset == name;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentConfig = config;
          _selectedPreset = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? Colors.white.withOpacity(0.2)
            : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: isSelected 
            ? Border.all(color: Colors.white.withOpacity(0.3))
            : null,
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
