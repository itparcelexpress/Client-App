import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/app_version_cubit.dart';
import '../widgets/app_version_dialog.dart';
import '../widgets/forced_update_screen.dart';
import '../../injections.dart';

/// Wrapper widget that handles app version checking and displays appropriate UI
class AppVersionWrapper extends StatelessWidget {
  final Widget child;

  const AppVersionWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppVersionCubit>()..initialize(),
      child: BlocConsumer<AppVersionCubit, AppVersionState>(
        listener: (context, state) {
          if (state is AppVersionUpdateRequired && !state.isForced) {
            // Show optional update dialog
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showUpdateDialog(context, state.versionResponse);
            });
          }
        },
        builder: (context, state) {
          print('🎯 AppVersionWrapper received state: ${state.runtimeType}');
          if (state is AppVersionUpdateRequired) {
            print('📋 Update required - isForced: ${state.isForced}');
          }

          if (state is AppVersionUpdateRequired && state.isForced) {
            print('🚨 Showing forced update screen');
            // Show forced update screen
            return ForcedUpdateScreen(versionResponse: state.versionResponse);
          } else if (state is AppVersionError && !state.canContinue) {
            print('❌ Showing error screen');
            // Show error screen if version check fails critically
            return _buildErrorScreen(context, state.message);
          } else {
            print('✅ Showing normal app content');
            // Show normal app content
            return child;
          }
        },
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, versionResponse) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppVersionDialog(versionResponse: versionResponse),
    );
  }

  Widget _buildErrorScreen(BuildContext context, String message) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 24),
              Text(
                'Version Check Failed',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.read<AppVersionCubit>().checkVersion();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
