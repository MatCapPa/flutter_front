import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_front/models/database_model.dart';
import 'package:flutter_front/providers/database_provider.dart';
import 'package:flutter_front/widgets/create_list.dart';
import 'package:flutter_front/widgets/drawer_menu.dart';
import 'package:flutter_front/widgets/spotify_appbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_front/helpers/database_preference.dart';
import 'package:http/http.dart' as http;


class ArtistsShowScreen extends StatefulWidget {
  const ArtistsShowScreen({super.key});

  @override
  State<ArtistsShowScreen> createState() => _ArtistsShowScreenState();
}

class _ArtistsShowScreenState extends State<ArtistsShowScreen> {
  String _mensaje = "";
  Future<List<ArtistDB>>? futureArtists;

  @override
  void initState() {
    super.initState();
    futureArtists = fetchArtists(); // Se ejecuta solo una vez
  }

  Future<List<ArtistDB>> fetchArtists() async {
    final uri = Uri.parse('https://nodejs-back-6tqt.onrender.com/db/artists/show');
    final apiKey = dotenv.env['API_KEY'] ?? '';
    try {
      final response = await http.get(
        uri,
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final data = databaseArtistFromJson(response.body);
        setState(() {
          _mensaje = 'Se encontraron ${data.length} artistas.';
          print(_mensaje);
        });
        return data;
      } else {
        setState(() {
          _mensaje = 'Error: ${response.statusCode}';
        });
        return [];
      }
    } catch (e) {
      setState(() {
        _mensaje = 'Error: $e';
      });
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final artistProvider = Provider.of<ArtistDBProvider>(context, listen: false);

    return Scaffold(
      appBar: SpotifyAppBar(),
      drawer: DrawerMenu(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ArtistDB>>(
              future: futureArtists , 
              builder: (BuildContext context, AsyncSnapshot<List<ArtistDB>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay artistas disponibles.'));
                } else {
                  final artists = snapshot.data!;
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: artists.length, //
                    itemBuilder: (BuildContext context, int index) {
                      final artist = artists[index];
                      return GestureDetector(
                        onTap: () {
                          artistProvider.setSelectedArtistDB(artist); // Guardamos el álbum
                          Navigator.pushNamed(context, 'artist_database_screen');
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: ListScreen(
                          id: artist.id, 
                          datoUno: artist.name, 
                          spotifyId: artist.spotifyid,
                          imageUrl: "", 
                        ),
                      );
                    },
                  );
                }
              },
            )
          ),
        ],
      ),
    );
  }
}