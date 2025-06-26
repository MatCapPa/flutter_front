import 'package:flutter/material.dart';
import 'package:flutter_front/models/database_model.dart';
import 'package:flutter_front/providers/database_provider.dart';
import 'package:flutter_front/widgets/create_list.dart';
import 'package:flutter_front/widgets/drawer_menu.dart';
import 'package:flutter_front/widgets/spotify_appbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_front/helpers/database_preference.dart';
import 'package:http/http.dart' as http;


class AlbumsShowScreen extends StatefulWidget {
  const AlbumsShowScreen({super.key});

  @override
  State<AlbumsShowScreen> createState() => _AlbumsShowScreenState();
}

class _AlbumsShowScreenState extends State<AlbumsShowScreen> {
  String _mensaje = "";
  Future<List<AlbumDB>>? futureAlbums;

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();
  }

  Future<List<AlbumDB>> fetchAlbums() async {
    final uri = Uri.parse('https://nodejs-back-6tqt.onrender.com/db/albums/show');

    try {
      final response = await http.get(
        uri,
        headers: {
          'x-api-key': 'apikeyutntup2025',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final data = databaseAlbumFromJson(response.body);
        setState(() {
          _mensaje = 'Se encontraron ${data.length} álbumes.';
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
    final albumProvider = Provider.of<AlbumDBProvider>(context, listen: false);

    return Scaffold(
      appBar: SpotifyAppBar(),
      drawer: DrawerMenu(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<AlbumDB>>(
              future: futureAlbums , 
              builder: (BuildContext context, AsyncSnapshot<List<AlbumDB>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay álbumes disponibles.'));
                } else {
                  final albums = snapshot.data!;
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: albums.length, 
                    itemBuilder: (BuildContext context, int index) {
                      final album = albums[index];
                      return GestureDetector(
                        onTap: () {
                          albumProvider.setSelectedAlbumDB(album);
                          Navigator.pushNamed(context, 'album_database_screen');
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: ListScreen(
                          id: album.id, 
                          datoUno: album.name, 
                          datoDos: album.releaseDate,   
                          datoTres: album.totalTracks, 
                          spotifyId: album.spotifyId,
                          imageUrl: album.imageUrl
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