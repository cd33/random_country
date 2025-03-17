import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'country_provider.dart';
import 'history_page.dart';
import 'country_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tirage au Sort de Pays'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CountryProvider>(
              builder: (context, provider, child) {
                final availableCount = provider.availableCountries.length;
                return Text(
                  'Pays restants: $availableCount',
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
            const SizedBox(height: 20),
            DrawCountryButton(),
          ],
        ),
      ),
    );
  }
}

class DrawCountryButton extends StatefulWidget {
  const DrawCountryButton({Key? key}) : super(key: key);

  @override
  _DrawCountryButtonState createState() => _DrawCountryButtonState();
}

class _DrawCountryButtonState extends State<DrawCountryButton> {
  String? _resultMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            textStyle: const TextStyle(fontSize: 24),
          ),
          onPressed: () {
            final provider = Provider.of<CountryProvider>(context, listen: false);
            final country = provider.drawRandomCountry();
            setState(() {
              if (country != null) {
                _resultMessage = 'Pays tiré: $country';
                // Naviguer vers la page de détails
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CountryDetailsPage(country: country),
                  ),
                );
              } else {
                _resultMessage = 'Tous les pays ont été tirés!';
              }
            });
          },
          child: const Text('TIRER UN PAYS'),
        ),
        if (_resultMessage != null)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              _resultMessage!,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}