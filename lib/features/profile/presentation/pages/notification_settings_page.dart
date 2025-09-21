import 'package:client_app/core/models/client_settings_models.dart';
import 'package:client_app/features/profile/cubit/client_settings_cubit.dart';
import 'package:client_app/features/profile/cubit/client_settings_state.dart';
import 'package:client_app/injections.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_app/core/widgets/loading_widgets.dart';

class NotificationSettingsPage extends StatelessWidget {
  final int userId;
  final int clientId;

  const NotificationSettingsPage({
    super.key,
    required this.userId,
    required this.clientId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => getIt<ClientSettingsCubit>()..loadClientSettings(userId),
      child: NotificationSettingsView(userId: userId, clientId: clientId),
    );
  }
}

class NotificationSettingsView extends StatelessWidget {
  final int userId;
  final int clientId;

  const NotificationSettingsView({
    super.key,
    required this.userId,
    required this.clientId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1a1a1a),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.notificationSettings,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
        ),
        actions: [
          BlocBuilder<ClientSettingsCubit, ClientSettingsState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<ClientSettingsCubit>().refreshClientSettings(
                    userId,
                  );
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: Color(0xFF667eea),
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ClientSettingsCubit, ClientSettingsState>(
        listener: (context, state) {
          if (state is ClientSettingsUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else if (state is ClientSettingsError ||
              state is ClientSettingsUpdateError) {
            final message =
                state is ClientSettingsError
                    ? state.message
                    : (state as ClientSettingsUpdateError).message;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<ClientSettingsCubit>().refreshClientSettings(userId);
            },
            child: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ClientSettingsState state) {
    if (state is ClientSettingsLoading) {
      return LoadingWidgets.fullScreenLoading();
    } else if (state is ClientSettingsLoaded) {
      return _buildSettingsList(context, state.settings);
    } else if (state is ClientSettingsError) {
      return _buildErrorState(context, state.message);
    }

    return _buildEmptyState(context);
  }

  Widget _buildSettingsList(BuildContext context, ClientSettingsData settings) {
    final notifications =
        settings.notifications ??
        const NotificationSettings(whatsapp: false, email: false);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildSettingsCard(context, notifications),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.manageNotificationPreferences,
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.chooseNotificationMethod,
          style: TextStyle(fontSize: 14, color: Colors.grey[500], height: 1.4),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    NotificationSettings notifications,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            context: context,
            title: AppLocalizations.of(context)!.whatsappNotifications,
            subtitle:
                AppLocalizations.of(context)!.receiveOrderUpdatesViaWhatsapp,
            icon: Icons.chat_rounded,
            iconColor: const Color(0xFF25D366),
            value: notifications.whatsapp,
            onChanged: (value) {
              context.read<ClientSettingsCubit>().toggleWhatsAppNotifications(
                userId,
                clientId,
              );
            },
          ),
          Divider(height: 1, color: Colors.grey[200]),
          _buildSettingTile(
            context: context,
            title: AppLocalizations.of(context)!.emailNotificationsTitle,
            subtitle: AppLocalizations.of(context)!.receiveOrderUpdatesViaEmail,
            icon: Icons.email_rounded,
            iconColor: const Color(0xFF1976D2),
            value: notifications.email,
            onChanged: (value) {
              context.read<ClientSettingsCubit>().toggleEmailNotifications(
                userId,
                clientId,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return BlocBuilder<ClientSettingsCubit, ClientSettingsState>(
      builder: (context, state) {
        final isUpdating = state is ClientSettingsUpdating;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          trailing:
              isUpdating
                  ? SizedBox(
                    width: 24,
                    height: 24,
                    child: LoadingWidgets.compactLoading(
                      color: Color(0xFF667eea),
                    ),
                  )
                  : Switch.adaptive(
                    value: value,
                    onChanged: isUpdating ? null : onChanged,
                    activeColor: const Color(0xFF667eea),
                    activeTrackColor: const Color(0xFF667eea).withOpacity(0.3),
                  ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.settings_rounded,
            size: 80,
            color: Color(0xFF667eea),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.loadingSettings,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.somethingWentWrong,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ClientSettingsCubit>().refreshClientSettings(userId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }
}
