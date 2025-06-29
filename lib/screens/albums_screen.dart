import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_front/helpers/album_preference.dart';
import 'package:flutter_front/models/album_model.dart';
import 'package:flutter_front/providers/album_provider.dart';
import 'package:flutter_front/widgets/create_card.dart';
import 'package:flutter_front/widgets/drawer_menu.dart';
import 'package:flutter_front/widgets/spotify_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  _AlbumsScreenState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  final TextEditingController _controller = TextEditingController();
  String _savedName = '';
  String _artistDetails = '';
  String _artistAlbumsDetails = '';
  String? _artistId;

  Future<List<Album>>? futureAlbums;

  Future<List<Album>> fetchAlbums(String _artistId) async {
    final uri = Uri.parse('https://nodejs-back-6tqt.onrender.com/api/$_artistId/albums');
    //final uri = Uri.parse('http://localhost:3000/api/$_artistId/albums');  //url para Chrome
    //final uri = Uri.parse('http://10.0.2.2:3000/api/artistas/$artistId/albums');     //url para Android

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = albumFromJson(response.body);
        setState(() {
          _artistAlbumsDetails = 'Se encontraron ${data.length} álbumes.';
        });
        return data;
      } else {
        setState(() {
          _artistAlbumsDetails = 'Error: ${response.statusCode}';
        });
        return [];
      }
    } catch (e) {
      setState(() {
        _artistAlbumsDetails = 'Error: $e';
      });
      return [];
    }
  }

  Future<void> searchArtist(String artistName) async {
    final uri = Uri.parse('https://nodejs-back-6tqt.onrender.com/api/search?q=$artistName');
    //final uri = Uri.parse('http://localhost:3000/api/search?q=$artistName');  //url para Chrome
    //final uri = Uri.parse('http://10.0.2.2:3000/api/artistas/search?q=$artistName');     //url para Android

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Respuesta de la API: $data');

        if (data['status'] == 'ok' && data['data'] != null) {
          final artistName = data['data']['nombre'];
          final artistId = data['data']['id'];

          setState(() {
            _artistId = artistId;
            _artistDetails = 'Artista: $artistName';
            futureAlbums = fetchAlbums(artistId);
          });
        } else {
          setState(() {
            _artistDetails = 'No se encontraron artistas.';
            _artistId = null;
          });
        }
      } else {
        setState(() {
          _artistDetails = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _artistDetails = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);

    return Scaffold(
      appBar: SpotifyAppBar(),
      drawer: DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Escribe el artista',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                setState(() {
                  _savedName = value; // guarda el valor al presionar Enter
                });
                searchArtist(value);
                _controller.clear(); // limpia el TextField
              },
            ),
            const SizedBox(height: 20),
            Text(
              '$_artistDetails \n $_artistAlbumsDetails',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Album>>(
                future: futureAlbums, 
                builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay álbumes disponibles.'));
                  } else {
                    final albums = snapshot.data!;
                    return ListView.builder(
                      itemCount: albums.length,
                      itemBuilder: (BuildContext context, int index) {
                        final album = albums[index];
                        return GestureDetector(
                          onTap: () {
                            albumProvider.setSelectedAlbum(album); // Guardamos el álbum
                            Navigator.pushNamed(context, 'album_tracks');
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: CardScreen(
                            url: album.imageUrl,
                            title: album.title,
                            body: album.releaseDate,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera recursos del controlador
    super.dispose();
  }
}