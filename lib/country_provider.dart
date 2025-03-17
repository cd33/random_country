import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'country_model.dart';

class CountryProvider extends ChangeNotifier {
  final List<String> _allCountries = [
    'Afghanistan', 'Afrique du Sud', 'Albanie', 'Algérie', 'Allemagne', 'Andorre', 'Angola', 
    'Antigua-et-Barbuda', 'Arabie Saoudite', 'Argentine', 'Arménie', 'Australie', 'Autriche', 
    'Azerbaïdjan', 'Bahamas', 'Bahreïn', 'Bangladesh', 'Barbade', 'Belgique', 'Belize', 
    'Bénin', 'Bhoutan', 'Biélorussie', 'Birmanie', 'Bolivie', 'Bosnie-Herzégovine', 
    'Botswana', 'Brésil', 'Brunei', 'Bulgarie', 'Burkina Faso', 'Burundi', 'Cambodge', 
    'Cameroun', 'Canada', 'Cap-Vert', 'Centrafrique', 'Chili', 'Chine', 'Chypre', 
    'Colombie', 'Comores', 'Congo', 'Corée du Nord', 'Corée du Sud', 'Costa Rica', 
    'Côte d\'Ivoire', 'Croatie', 'Cuba', 'Danemark', 'Djibouti', 'Dominique', 'Égypte', 
    'Émirats arabes unis', 'Équateur', 'Érythrée', 'Espagne', 'Estonie', 'Eswatini', 
    'États-Unis', 'Éthiopie', 'Fidji', 'Finlande', 'France', 'Gabon', 'Gambie', 
    'Géorgie', 'Ghana', 'Grèce', 'Grenade', 'Guatemala', 'Guinée', 'Guinée équatoriale', 
    'Guinée-Bissau', 'Guyana', 'Haïti', 'Honduras', 'Hongrie', 'Îles Marshall', 
    'Îles Salomon', 'Inde', 'Indonésie', 'Irak', 'Iran', 'Irlande', 'Islande', 'Israël', 
    'Italie', 'Jamaïque', 'Japon', 'Jordanie', 'Kazakhstan', 'Kenya', 'Kirghizistan', 
    'Kiribati', 'Koweït', 'Laos', 'Lesotho', 'Lettonie', 'Liban', 'Liberia', 'Libye', 
    'Liechtenstein', 'Lituanie', 'Luxembourg', 'Macédoine du Nord', 'Madagascar', 'Malaisie', 
    'Malawi', 'Maldives', 'Mali', 'Malte', 'Maroc', 'Maurice', 'Mauritanie', 'Mexique', 
    'Micronésie', 'Moldavie', 'Monaco', 'Mongolie', 'Monténégro', 'Mozambique', 'Namibie', 
    'Nauru', 'Népal', 'Nicaragua', 'Niger', 'Nigeria', 'Niue', 'Norvège', 'Nouvelle-Zélande', 
    'Oman', 'Ouganda', 'Ouzbékistan', 'Pakistan', 'Palaos', 'Palestine', 'Panama', 
    'Papouasie-Nouvelle-Guinée', 'Paraguay', 'Pays-Bas', 'Pérou', 'Philippines', 'Pologne', 
    'Portugal', 'Qatar', 'République démocratique du Congo', 'République dominicaine', 
    'République tchèque', 'Roumanie', 'Royaume-Uni', 'Russie', 'Rwanda', 'Saint-Kitts-et-Nevis', 
    'Saint-Vincent-et-les-Grenadines', 'Sainte-Lucie', 'Saint-Marin', 'Salvador', 'Samoa', 
    'São Tomé-et-Principe', 'Sénégal', 'Serbie', 'Seychelles', 'Sierra Leone', 'Singapour', 
    'Slovaquie', 'Slovénie', 'Somalie', 'Soudan', 'Soudan du Sud', 'Sri Lanka', 'Suède', 
    'Suisse', 'Suriname', 'Syrie', 'Tadjikistan', 'Tanzanie', 'Tchad', 'Thaïlande', 'Timor oriental', 
    'Togo', 'Tonga', 'Trinité-et-Tobago', 'Tunisie', 'Turkménistan', 'Turquie', 'Tuvalu', 
    'Ukraine', 'Uruguay', 'Vanuatu', 'Vatican', 'Venezuela', 'Viêt Nam', 'Yémen', 'Zambie', 
    'Zimbabwe'
  ];
  List<Country> _drawnCountries = [];
  final Random _random = Random();
  static const String _storageKey = 'drawn_countries';

  CountryProvider() {
    _loadCountries();
  }

  // Getter pour les pays déjà tirés
  List<Country> get drawnCountries => _drawnCountries;

  // Getter pour obtenir les noms des pays tirés
  List<String> get drawnCountryNames => _drawnCountries.map((country) => country.name).toList();

  // Getter pour obtenir les pays encore disponibles
  List<String> get availableCountries {
    return _allCountries.where((country) => 
      !drawnCountryNames.contains(country)).toList();
  }

  // Méthode pour tirer un pays au hasard
  String? drawRandomCountry() {
    if (availableCountries.isEmpty) {
      return null; // Tous les pays ont été tirés
    }
    final index = _random.nextInt(availableCountries.length);
    final selectedCountry = availableCountries[index];

    // Créer un nouvel objet Country sans description (sera ajoutée plus tard)
    final country = Country(name: selectedCountry);
    _drawnCountries.add(country);

    _saveCountries();
    notifyListeners();
    return selectedCountry;
  }

  // Méthode pour réinitialiser les pays tirés
  void resetDrawnCountries() {
    _drawnCountries.clear();
    _saveCountries();
    notifyListeners();
  }

  // Méthode pour supprimer un pays de l'historique
  void removeCountry(String countryName) {
    _drawnCountries.removeWhere((country) => country.name == countryName);
    _saveCountries();
    notifyListeners();
  }

  // Méthode pour charger les pays de SharedPreferences
  Future<void> _loadCountries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final countriesJson = prefs.getStringList(_storageKey) ?? [];

      _drawnCountries = countriesJson
          .map((json) => Country.fromJson(json))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement des pays: $e');
    }
  }

  // Méthode pour sauvegarder les pays dans SharedPreferences
  Future<void> _saveCountries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final countriesJson = _drawnCountries
          .map((country) => country.toJson())
          .toList();

      await prefs.setStringList(_storageKey, countriesJson);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde des pays: $e');
    }
  }

  // Méthode pour mettre à jour la description d'un pays
  Future<void> updateCountryDescription(String countryName, String description) async {
    final index = _drawnCountries.indexWhere((country) => country.name == countryName);
    if (index != -1) {
      // Créer un nouveau Country avec la description mise à jour
      final updatedCountry = Country(
        name: countryName, 
        description: description,
        dateAdded: _drawnCountries[index].dateAdded
      );

      _drawnCountries[index] = updatedCountry;
      await _saveCountries();
      notifyListeners();
    }
  }

  // Méthode pour obtenir la description d'un pays s'il existe
  String? getCountryDescription(String countryName) {
    final country = _drawnCountries.firstWhere(
      (c) => c.name == countryName,
      orElse: () => Country(name: '')
    );
    return country.name.isNotEmpty ? country.description : null;
  }
}