import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../cubit/app_version_cubit.dart';
import '../models/app_version_models.dart';
import '../services/app_version_service.dart';
import '../../injections.dart';

/// Full-screen blocking widget for forced updates
class ForcedUpdateScreen extends StatelessWidget {
  final AppVersionResponse versionResponse;

  const ForcedUpdateScreen({super.key, required this.versionResponse});

  @override
  Widget build(BuildContext context) {
    // Disable system UI and prevent back navigation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return PopScope(
      canPop: false, // Prevent back navigation
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(),
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildVersionInfo(context),
                const SizedBox(height: 24),
                _buildChangelog(context),
                const Spacer(),
                _buildUpdateButton(context),
                const SizedBox(height: 16),
                _buildWarningMessage(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // App Logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
          ),
          child: Icon(
            Icons.system_update,
            size: 60,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        // Title
        Text(
          AppLocalizations.of(context)?.update_required ?? 'Update Required',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Subtitle
        Text(
          AppLocalizations.of(context)?.critical_update_required ??
              'Critical update required. Please update immediately.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    // Get current app version info
    final appVersionService = getIt<AppVersionService>();
    final currentVersionInfo = appVersionService.getCurrentVersionInfo();

    // Format current version with build number
    final currentVersionDisplay =
        '${currentVersionInfo.version}+${currentVersionInfo.buildNumber}';

    // Format latest version with build number
    final latestVersionDisplay =
        '${versionResponse.latestVersion}+${versionResponse.latestBuild}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.current_version ??
                    'Current Version:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                currentVersionDisplay,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.latest_version ??
                    'Latest Version:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                latestVersionDisplay,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChangelog(BuildContext context) {
    if (versionResponse.changelog.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s New',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            versionResponse.changelog,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.blue[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _handleUpdate(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: BlocBuilder<AppVersionCubit, AppVersionState>(
          builder: (context, state) {
            if (state is AppVersionUpdateInProgress) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }
            return Text(
              AppLocalizations.of(context)?.update_now ?? 'Update Now',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWarningMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red[600], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)?.forced_update_warning_message ??
                  'You must update the app to continue using it. The app will not function until you install the latest version.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleUpdate(BuildContext context) {
    context.read<AppVersionCubit>().forceUpdate();
  }
}
