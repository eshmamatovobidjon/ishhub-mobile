num? parsePositiveAmount(String value) {
  final amount = num.tryParse(value.trim());
  if (amount == null || amount <= 0) return null;
  return amount;
}

double? parseOptionalPositiveHours(String value) {
  final raw = value.trim();
  if (raw.isEmpty) return null;
  final hours = double.tryParse(raw);
  if (hours == null || hours <= 0) return null;
  return hours;
}

bool hasInvalidOptionalHours(String value) {
  final raw = value.trim();
  return raw.isNotEmpty && parseOptionalPositiveHours(raw) == null;
}
