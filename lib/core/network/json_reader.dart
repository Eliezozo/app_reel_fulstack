import '../error/app_exception.dart';
import '../config/app_strings.dart';

List<Map<String, dynamic>> readDataList(Object? body) {
  if (body is! Map) {
    throw const AppException(AppStrings.invalidPayload);
  }
  final data = body['data'];
  if (data is! List) {
    throw const AppException(AppStrings.invalidPayload);
  }
  return data.map((item) {
    if (item is! Map) {
      throw const AppException(AppStrings.invalidPayload);
    }
    return Map<String, dynamic>.from(item);
  }).toList(growable: false);
}
