/// Calculates age in full years from the given [birthDate].
int calculateAgeInYears(DateTime birthDate) {
  final today = DateTime.now();
  int age = today.year - birthDate.year;

  // Adjust if birthday hasn't occurred yet this year
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }

  return age;
}

/// Calculates age in total months from the given [birthDate].
int calculateAgeInMonths(DateTime birthDate) {
  final today = DateTime.now();
  return (today.year - birthDate.year) * 12 + (today.month - birthDate.month);
}

/// Returns a formatted age string based on [birthDate].
/// - If age ≤ 2 years, returns age in months.
/// - Otherwise, returns age in years.
String formatAge(DateTime birthDate) {
  final years = calculateAgeInYears(birthDate);
  final months = calculateAgeInMonths(birthDate);

  if (years <= 2) {
    return "$months months";
  } else {
    return "$years years";
  }
}
