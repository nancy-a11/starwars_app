class Character {
  final String name;
  final String height;
  final String mass;
  final String birthYear;
  final String created;
  final List<String> films;

  const Character({
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
    return h == null ? 'Unknown' : '${(h / 100).toStringAsFixed(2)} m';
  }

  String get massInKg {
    final val = double.tryParse(mass.replaceAll(',', ''));
    return val == null ? 'Unknown' : '${val.toStringAsFixed(0)} kg';
  }
}
