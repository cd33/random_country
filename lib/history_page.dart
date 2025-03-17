import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'country_provider.dart';
import 'country_details_page.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Pays Tirés'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Réinitialiser',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Réinitialiser'),
                    content: const Text(
                      'Voulez-vous réinitialiser la liste des pays tirés?'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<CountryProvider>(context, listen: false)
                              .resetDrawnCountries();
                          Navigator.pop(context);
                        },
                        child: const Text('Réinitialiser'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<CountryProvider>(
        builder: (context, provider, child) {
          final countries = provider.drawnCountries;
          if (countries.isEmpty) {
            return const Center(
              child: Text(
                'Aucun pays n\'a été tiré pour le moment',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              final formattedDate = dateFormat.format(country.dateAdded);

              // Créer un extrait de la description si elle existe
              final hasDescription = country.description != null && 
                                    country.description!.isNotEmpty;
              final previewText = hasDescription
                  ? country.description!.length > 100
                      ? '${country.description!.substring(0, 100)}...'
                      : country.description
                  : 'Aucune description disponible';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    country.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Ajouté le $formattedDate',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (hasDescription)
                        Text(
                          previewText!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountryDetailsPage(
                          country: country.name,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<CountryProvider>(context, listen: false)
                          .removeCountry(country.name);
                    },
                    tooltip: 'Supprimer de l\'historique',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}