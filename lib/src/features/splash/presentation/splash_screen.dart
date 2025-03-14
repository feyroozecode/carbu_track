import 'dart:async';
import 'package:carbu_track/src/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import '../../../common/constants/app_colors.dart';
import '../../home/core/presentation/home_screen.dart';
import '../../home/core/presentation/providers/location_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _radiusAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
    
    _radiusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    // Start animation
    _animationController.forward();
    
    // Request location permission
    //_requestLocationPermission();
    
    // Navigate to home screen after 5 seconds
    Timer(const Duration(seconds: 5), () {
      // GOROUTER page replacement to home screen
      context.pushReplacement(AppRoutes.home.path, );
    });
  }
  
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with scale animation
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_gas_station,
                        color: AppColors.primary,
                        size: 70,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // App name with fade in animation
                Opacity(
                  opacity: _opacityAnimation.value,
                  child: const Text(
                    'CarbuTrack',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Tagline with fade in animation
                Opacity(
                  opacity: _opacityAnimation.value,
                  child: Text(
                    'Trouvez les meilleures stations-service',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Circular loading animation
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer rotating circle
                    Transform.rotate(
                      angle: _rotationAnimation.value * 3.14,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.5),
                            width: 4,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                          gradient: SweepGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.1),
                              AppColors.primary,
                            ],
                            stops: const [0.75, 1.0],
                          ),
                        ),
                      ),
                    ),
                    
                    // Inner circle with pulsing animation
                    Container(
                      width: 50 * _radiusAnimation.value,
                      height: 50 * _radiusAnimation.value,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.local_gas_station,
                        color: AppColors.primary,
                        size: 24 * _radiusAnimation.value,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}