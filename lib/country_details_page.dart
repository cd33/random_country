import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'openai_service.dart';
import 'country_provider.dart';

class CountryDetailsPage extends StatefulWidget {
  final String country;
  const CountryDetailsPage({Key? key, required this.country}) : super(key: key);
  @override
  State<CountryDetailsPage> createState() => _CountryDetailsPageState();
}

class _CountryDetailsPageState extends State<CountryDetailsPage> {
  String _countryInfo = 'Chargement des informations...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCountryInfo();
  }

  Future<void> _loadCountryInfo() async {
    final provider = Provider.of<CountryProvider>(context, listen: false);

    // Vérifier si nous avons déjà une description enregistrée
    final savedDescription = provider.getCountryDescription(widget.country);

    if (savedDescription != null) {
      // Utiliser la description sauvegardée
      setState(() {
        _countryInfo = savedDescription;
        _isLoading = false;
      });
    } else {
      // Sinon, obtenir une nouvelle description via OpenAI
      final info = await OpenAIService.getCountryInfo(widget.country);

      // Enregistrer la description obtenue
      await provider.updateCountryDescription(widget.country, info);

      setState(() {
        _countryInfo = info;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.country,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Ajout d'un bouton pour rafraîchir les informations
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser les informations',
            onPressed: _isLoading
              ? null
              : () async {
                setState(() {
                  _isLoading = true;
                  _countryInfo = 'Actualisation des informations...';
                });

                final info = await OpenAIService.getCountryInfo(widget.country);
                await Provider.of<CountryProvider>(context, listen: false)
                    .updateCountryDescription(widget.country, info);

                setState(() {
                  _countryInfo = info;
                  _isLoading = false;
                });
              },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SelectableText(
                        _countryInfo,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}