import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'country_provider.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'openai_service.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Tentative de chargement du fichier .env avec message d'erreur explicite
    bool envLoaded = false;
    try {
      await dotenv.load(fileName: ".env");
      envLoaded = true;
    } catch (e) {
      debugPrint('Erreur lors du chargement du fichier .env: $e\n'
          'Assurez-vous que le fichier .env existe à la racine du projet avec une clé API valide.');
    }

    // Vérification et initialisation de l'API OpenAI
    if (envLoaded) {
      final apiKey = dotenv.env['OPENROUTER_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('La clé API OpenAI n\'est pas configurée correctement dans le fichier .env');
      }
      OpenAIService.initialize(apiKey);
    }

    runApp(
      ChangeNotifierProvider(
        create: (context) => CountryProvider(),
        child: const MyApp(),
      ),
    );
  } catch (e) {
    debugPrint('Erreur lors de l\'initialisation: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Erreur de configuration: $e\n\n'
              'Veuillez vérifier votre fichier .env et votre clé API.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tirage de Pays Aléatoire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
