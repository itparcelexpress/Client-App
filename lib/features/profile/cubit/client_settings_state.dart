import 'package:client_app/core/models/client_settings_models.dart';
import 'package:equatable/equatable.dart';

abstract class ClientSettingsState extends Equatable {
  const ClientSettingsState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ClientSettingsInitial extends ClientSettingsState {}

// Loading states
class ClientSettingsLoading extends ClientSettingsState {}

class ClientSettingsUpdating extends ClientSettingsState {}

// Success states
class ClientSettingsLoaded extends ClientSettingsState {
  final ClientSettingsData settings;

  const ClientSettingsLoaded({required this.settings});

  @override
  List<Object?> get props => [settings];
}

class ClientSettingsUpdateSuccess extends ClientSettingsState {
  final ClientSettingsData updatedSettings;
  final String message;

  const ClientSettingsUpdateSuccess({
    required this.updatedSettings,
    required this.message,
  });

  @override
  List<Object?> get props => [updatedSettings, message];
}

// Error states
class ClientSettingsError extends ClientSettingsState {
  final String message;
  final String? errorCode;

  const ClientSettingsError(this.message, {this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

class ClientSettingsUpdateError extends ClientSettingsState {
  final String message;
  final ClientSettingsData? currentSettings;

  const ClientSettingsUpdateError(this.message, {this.currentSettings});

  @override
  List<Object?> get props => [message, currentSettings];
}
