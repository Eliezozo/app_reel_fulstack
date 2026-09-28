import '../../../core/config/app_strings.dart';

String? validateRequired(String? value) {
  if (value == null || value.trim().isEmpty) return AppStrings.requiredField;
  return null;
}

String? validateName(String? value) {
  final requiredError = validateRequired(value);
  if (requiredError != null) return requiredError;
  if ((value?.trim().length ?? 0) < 2) return AppStrings.shortName;
  return null;
}

String? validateEmail(String? value) {
  final requiredError = validateRequired(value);
  if (requiredError != null) return requiredError;
  final email = value?.trim() ?? '';
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    return AppStrings.invalidEmail;
  }
  return null;
}

String? validatePassword(String? value) {
  final requiredError = validateRequired(value);
  if (requiredError != null) return requiredError;
  if ((value?.length ?? 0) < 6) return AppStrings.shortPassword;
  return null;
}
