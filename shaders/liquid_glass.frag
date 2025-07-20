#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture;
uniform float u_distortion_intensity;
uniform float u_animation_speed;
uniform vec2 u_touch_point;
uniform float u_touch_radius;

out vec4 fragColor;

// Noise function for more realistic liquid distortion
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// Smooth noise for organic movement
float smoothNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float a = noise(i);
    float b = noise(i + vec2(1.0, 0.0));
    float c = noise(i + vec2(0.0, 1.0));
    float d = noise(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Fractal noise for complex distortion patterns
float fractalNoise(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    
    for (int i = 0; i < 4; i++) {
        value += amplitude * smoothNoise(p * frequency);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    
    return value;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / u_resolution;
    vec2 originalUV = uv;
    
    // Time-based animation with configurable speed
    float time = u_time * u_animation_speed;
    
    // Create multiple wave layers for realistic liquid movement
    float wave1 = sin(uv.y * 20.0 + time * 1.5) * 0.005;
    float wave2 = cos(uv.x * 25.0 + time * 2.0) * 0.004;
    float wave3 = sin((uv.x + uv.y) * 15.0 + time * 1.8) * 0.003;
    
    // Add fractal noise for organic distortion
    vec2 noiseOffset = vec2(time * 0.1, time * 0.15);
    float noiseDistortion = fractalNoise(uv * 8.0 + noiseOffset) * 0.008;
    
    // Combine all distortions
    vec2 distortion = vec2(wave1 + wave3, wave2 + wave3) + noiseDistortion;
    distortion *= u_distortion_intensity;
    
    // Add touch interaction ripple effect
    if (u_touch_radius > 0.0) {
        vec2 touchDist = uv - u_touch_point;
        float dist = length(touchDist);
        
        if (dist < u_touch_radius) {
            float ripple = sin(dist * 30.0 - time * 8.0) * exp(-dist * 5.0);
            distortion += touchDist * ripple * 0.02;
        }
    }
    
    // Apply distortion to UV coordinates
    uv += distortion;
    
    // Sample the texture with distorted coordinates
    vec4 texColor = texture(u_texture, uv);
    
    // Add subtle chromatic aberration for glass-like refraction
    float aberration = 0.002;
    float r = texture(u_texture, uv + vec2(aberration, 0.0)).r;
    float g = texture(u_texture, uv).g;
    float b = texture(u_texture, uv - vec2(aberration, 0.0)).b;
    
    texColor.rgb = vec3(r, g, b);
    
    // Enhance brightness and add glass-like transparency
    texColor.rgb *= 1.1;
    texColor.a = 0.85;
    
    // Add subtle edge highlighting for glass effect
    float edgeFactor = 1.0 - smoothstep(0.0, 0.1, min(min(originalUV.x, 1.0 - originalUV.x), min(originalUV.y, 1.0 - originalUV.y)));
    texColor.rgb += vec3(0.1) * edgeFactor;
    
    fragColor = texColor;
}
