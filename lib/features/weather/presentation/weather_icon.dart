import 'package:flutter/material.dart';

IconData weatherIcon(int code) {
  if (code == 0) return Icons.wb_sunny_outlined;
  if (code <= 3) return Icons.wb_cloudy_outlined;
  if (code <= 48) return Icons.blur_on;
  if (code <= 67) return Icons.grain;
  if (code <= 77) return Icons.ac_unit_outlined;
  if (code <= 82) return Icons.water_drop_outlined;
  return Icons.thunderstorm_outlined;
}
