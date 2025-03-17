import 'dart:convert';

class Country {
  final String name;
  final String? description;
  final DateTime dateAdded;

  Country({
    required this.name,
    this.description,
    DateTime? dateAdded,
  }) : dateAdded = dateAdded ?? DateTime.now();

  // Convertir l'objet Country en Map pour le stockage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  // Créer un objet Country à partir d'une Map
  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      name: map['name'],
      description: map['description'],
      dateAdded: DateTime.parse(map['dateAdded']),
    );
  }

  // Convertir en JSON
  String toJson() => jsonEncode(toMap());

  // Créer à partir de JSON
  factory Country.fromJson(String source) => Country.fromMap(jsonDecode(source));
}