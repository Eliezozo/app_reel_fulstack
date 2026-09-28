import '../config/app_strings.dart';

String formatGrouped(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  if (value < 0) buffer.write('-');
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      buffer.write('\u202f');
    }
    buffer.write(digits[index]);
  }
  return buffer.toString();
}

String formatXof(double price) => '${formatGrouped(price.round())} F CFA';

String formatChange(double value) {
  final sign = value > 0 ? '+' : '';
  final digits = value.toStringAsFixed(1).replaceAll('.', ',');
  return '$sign$digits %';
}

String formatPublished(String iso) {
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  final local = date.toLocal();
  const months = [
    'janv.',
    'févr.',
    'mars',
    'avr.',
    'mai',
    'juin',
    'juil.',
    'août',
    'sept.',
    'oct.',
    'nov.',
    'déc.',
  ];
  return '${local.day} ${months[local.month - 1]} ${local.year}';
}

String formatWeekday(String isoDate) {
  final date = DateTime.tryParse(isoDate);
  if (date == null) return isoDate;
  const days = ['lun.', 'mar.', 'mer.', 'jeu.', 'ven.', 'sam.', 'dim.'];
  return '${days[date.weekday - 1]} ${date.day}/${date.month}';
}

String greetingFor(String name) {
  final first = name.trim().split(' ').first;
  final hello = DateTime.now().hour < 18 ? AppStrings.helloDay : AppStrings.helloEvening;
  return '$hello, $first';
}
