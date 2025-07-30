import 'package:flutter/material.dart';
import 'package:client_app/core/utilities/app_endpoints.dart';

class EnvironmentBanner extends StatelessWidget {
  const EnvironmentBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // Only show banner in test environment
    if (!AppEndPoints.isTestEnvironment) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.orange,
      child: const Text(
        'TEST ENVIRONMENT',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 