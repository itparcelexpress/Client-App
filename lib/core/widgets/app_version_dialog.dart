import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../cubit/app_version_cubit.dart';
import '../models/app_version_models.dart';
import '../services/app_version_service.dart';
import '../../injections.dart';

/// Modal dialog for optional updates
class AppVersionDialog extends StatelessWidget {
  final AppVersionResponse versionResponse;

  const AppVersionDialog({super.key, required this.versionResponse});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildVersionInfo(context),
            const SizedBox(height: 16),
            _buildChangelog(context),
            const SizedBox(height: 24),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Update Icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
          ),
          child: Icon(
            Icons.system_update,
            size: 32,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        // Title
        Text(
          AppLocalizations.of(context)?.update_available ?? 'Update Available',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Subtitle
        Text(
          AppLocalizations.of(context)?.update_available_message ??
              'New version available with improvements.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
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
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                currentVersionDisplay,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.latest_version ??
                    'Latest Version:',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                latestVersionDisplay,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s New',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            versionResponse.changelog,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.blue[700],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _handleLater(context),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              AppLocalizations.of(context)?.later ?? 'Later',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleUpdate(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: BlocBuilder<AppVersionCubit, AppVersionState>(
              builder: (context, state) {
                if (state is AppVersionUpdateInProgress) {
                  return const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
                return Text(
                  AppLocalizations.of(context)?.update_now ?? 'Update Now',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _handleLater(BuildContext context) {
    context.read<AppVersionCubit>().dismissUpdate();
    Navigator.of(context).pop();
  }

  void _handleUpdate(BuildContext context) {
    context.read<AppVersionCubit>().forceUpdate();
  }
}
