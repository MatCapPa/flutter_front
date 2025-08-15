import 'dart:convert';

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


class TracksShowScreen extends StatefulWidget {
  const TracksShowScreen({super.key});

  @override
  State<TracksShowScreen> createState() => _TracksShowScreenState();
}

class _TracksShowScreenState extends State<TracksShowScreen> {
  String _mensaje = "";
  Future<List<TrackDB>>? futureTrack;

  @override
  void initState() {
    super.initState();
    futureTrack = fetchTracks();
  }

  Future<List<TrackDB>> fetchTracks() async {
    final uri = Uri.parse('https://nodejs-back-6tqt.onrender.com/db/tracks/show');
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
        final data = databaseTrackFromJson(response.body);
        
        setState(() {
          _mensaje = 'Se encontraron ${data.length} pistas.';
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
    final trackProvider = Provider.of<TrackDBProvider>(context, listen: false);

    return Scaffold(
      appBar: SpotifyAppBar(),
      drawer: DrawerMenu(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<TrackDB>>(
              future: futureTrack , 
              builder: (BuildContext context, AsyncSnapshot<List<TrackDB>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay pistas disponibles.'));
                } else {
                  final tracks = snapshot.data!;
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tracks.length, //
                    itemBuilder: (BuildContext context, int index) {
                      final track = tracks[index];
                      return GestureDetector(
                        onTap: () {
                          trackProvider.setSelectedTrackDB(track); // Guardamos el álbum
                          Navigator.pushNamed(context, 'track_database_screen');
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: ListScreen(
                          id: track.id, 
                          datoUno: track.name,
                          datoDos: track.trackNumber.toString(),
                          spotifyId: track.spotifyid,
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