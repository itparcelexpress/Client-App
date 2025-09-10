String mapLoginErrorToKey({required String? message, List<String>? errors}) {
  final msg = (message ?? '').toLowerCase().trim();

  // Common backend messages mapping
  if (msg.contains('password is incorrect')) {
    return 'loginErrorIncorrectPassword';
  }
  if (msg.contains('no account found') || msg.contains('no account')) {
    return 'loginErrorNoAccount';
  }
  if (msg.contains('disabled') || msg.contains('inactive')) {
    return 'loginErrorAccountDisabled';
  }
  if (msg.contains('too many') || msg.contains('attempts')) {
    return 'loginErrorTooManyAttempts';
  }
  if (msg.contains('validation') ||
      msg.contains('invalid') ||
      msg.contains('required')) {
    return 'loginErrorValidation';
  }

  // Heuristic based on error codes in list when present
  if (errors != null && errors.isNotEmpty) {
    final joined = errors.join(' ').toLowerCase();
    if (joined.contains('402')) {
      // Treat as invalid credentials
      return 'loginFailed';
    }
  }

  return msg.isNotEmpty ? 'loginFailed' : 'loginErrorUnknown';
}
