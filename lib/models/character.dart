class Character {
  final String name;
  final String height;
  final String mass;
  final String birthYear;
  final String created;
  final List<String> films;

  Character({
    required this.name,
    required this.height,
    required this.mass,
    required this.birthYear,
    required this.created,
    required this.films,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? 'Unknown',
      height: json['height'] ?? 'unknown',
      mass: json['mass'] ?? 'unknown',
      birthYear: json['birth_year'] ?? 'unknown',
      created: json['created'] ?? '',
      films: List<String>.from(json['films'] ?? []),
    );
  }

  String get heightInMeters {
    final h = double.tryParse(height);
    if (h == null) return 'Unknown';
    return '${(h / 100).toStringAsFixed(2)} m';
  }

  String get massInKg {
    final m = mass.replaceAll(',', '');
    final val = double.tryParse(m);
    if (val == null) return 'Unknown';
    return '${val.toStringAsFixed(0)} kg';
  }

  String get formattedCreatedDate {
    try {
      final date = DateTime.parse(created);
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();
      return '$day-$month-$year';
    } catch (_) {
      return 'Unknown';
    }
  }
}
