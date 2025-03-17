import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static String? _apiKey;
  static const String _baseUrl = 'https://openrouter.ai/api/v1';

  static const String _systemPrompt = """
Tu es un expert en culture et histoire des pays. Formate ta réponse en sections claires avec des emoji appropriés.
Pour chaque pays, tu dois fournir les sections suivantes :

🍳 RECETTES TYPIQUES
• Liste de 3 recettes avec une courte description

🎬 FILMS EMBLÉMATIQUES
• Liste de 3 films avec leur année et réalisateur

📖 PRÉSENTATION DU PAYS
• Histoire
• Géographie
• Culture

Utilise des retours à la ligne et des puces pour une meilleure lisibilité.
""";

  static Future<String> getCountryInfo(String country) async {
    if (_apiKey == null) {
      return 'Erreur: API key non initialisée';
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json; charset=utf-8',
          'HTTP-Referer': 'https://random-country-app.com', // Remplacez par votre domaine
        },
        body: jsonEncode({
          'model': 'deepseek/deepseek-r1:free',
          'messages': [
            {
              'role': 'system',
              'content': _systemPrompt
            },
            {
              'role': 'user',
              'content': 'Donne-moi des informations sur $country'
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'] ??
               'Aucune information disponible pour $country';
      } else {
        throw Exception('Erreur API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      return 'Erreur lors de la récupération des informations: $e';
    }
  }

  static void initialize(String apiKey) {
    _apiKey = apiKey;
  }
}