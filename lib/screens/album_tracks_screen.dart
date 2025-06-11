import 'package:flutter/material.dart';
import 'package:flutter_front/helpers/tracks_preference.dart';
import 'package:flutter_front/models/track_model.dart';
import 'package:flutter_front/providers/album_provider.dart';
import 'package:flutter_front/widgets/spotify_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AlbumTracksScreen extends StatefulWidget {
  const AlbumTracksScreen({super.key});

  @override
  State<AlbumTracksScreen> createState() => _AlbumTracksScreenState();
}

class _AlbumTracksScreenState extends State<AlbumTracksScreen> {
  String? _savedData;
  late Future<List<Tracks>> futureTracks;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final album = Provider.of<AlbumProvider>(context).selectedAlbum;
    if (album != null) {
      futureTracks = fetchTracks(album.id);
    }
  }

  Future<List<Tracks>> fetchTracks(String albumId) async { 
    //final uri = Uri.parse('https://nodejs-back-6tqt.onrender.com/api/albums/tracks/${albumId});
    final uri = Uri.parse('http://localhost:3000/api/albums/tracks/${albumId}');  //url para Chrome

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = trackFromJson(response.body);
        
        setState(() {
          _savedData = 'Se encontraron ${data.length} canciones (tracks).';
        });
        return data;
      } else {
        setState(() {
          _savedData = 'error: ${response.statusCode}';
        });
        return [];
      }
    } catch (e) {
      setState(() {
        _savedData = 'Error: $e';
      });
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final album = Provider.of<AlbumProvider>(context).selectedAlbum;
    if (album == null) {
      return const Scaffold(
        body: Center(child: Text('No se ha seleccionado ningún álbum')),
      );
    }

    return Scaffold(
      appBar: AppBar(),//SpotifyAppBar(),
      //drawer: DrawerMenu(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
            album.imageUrl,
            fit: BoxFit.cover,
            ),
          ) ,
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  album.title, // Título del álbum
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Tracks>>(
                future: futureTracks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No se encontraron canciones'));
                  } else {
                    final tracks = snapshot.data!;
                    return ListView.builder(
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        final track = tracks[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).cardColor,
                            child: Text('${track.track_number}'),
                          ),
                          title: Text(track.name,style: const TextStyle(color: Colors.white)),
                        );
                      },
                    );
                  }
                },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}