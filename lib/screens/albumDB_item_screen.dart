import 'package:flutter/material.dart';
import 'package:flutter_front/providers/database_provider.dart';
import 'package:provider/provider.dart';

class AlbumDatabaseScreen extends StatefulWidget {
  const AlbumDatabaseScreen({super.key});

  @override
  State<AlbumDatabaseScreen> createState() => _AlbumDatabaseScreenState();
}

class _AlbumDatabaseScreenState extends State<AlbumDatabaseScreen> {
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _releaseDateController = TextEditingController();
  final TextEditingController _totalTracksController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _releaseDateController.dispose();
    _totalTracksController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<AlbumDBProvider>(context);
    final album = Provider.of<AlbumDBProvider>(context).selectedAlbum;
    if (album == null) {
      return const Scaffold(
        body: Center(child: Text('No se ha seleccionado ningún álbum')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.40,
              color: const Color(0xff2d3e4f),
              child: Center(
                child: CircleAvatar(
                  radius: 100,
                  child: album.imageUrl != ""
                      ? Image.network(album.imageUrl)
                      : Image.asset('assets/1200px-Spotify.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text('Spotify Id: ${album.spotifyId}'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      fillColor: Colors.black,
                      label: Text("Nombre"),
                      helperText: 'Editar Nombre'
                    ),
                    onChanged: (value) => print('Nombre actualizado: $value'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _releaseDateController,
                    decoration: const InputDecoration(
                      fillColor: Colors.black,
                      label: Text("Fecha de lanzamiento"),
                      helperText: 'Editar Fecha'
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _totalTracksController,
                    decoration: const InputDecoration(
                      fillColor: Colors.black,
                      label: Text("Cantidad de pistas"),
                      helperText: 'Editar Cantidad de pistas'
                    ),
                    
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final name = _nameController.text.trim();
                          final releaseDate = _releaseDateController.text.trim();
                          final totalTracks = int.parse(_totalTracksController.text.trim());
                          if (name.isEmpty || releaseDate.isEmpty || totalTracks == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('El nombre no puede estar vacío')),
                            );
                            return;
                          }
                          try {
                            await provider.actualizarAlbumDB(album.id, name, releaseDate, totalTracks);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Datos actualizados')),
                            );
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error al actualizzzar')),
                            );
                          }
                        },
                        child: const Text('Guardar'),
                      ),
                      const SizedBox(width: 16,),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await provider.borrarAlbumDB(album.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Datos eliminados')),
                            );
                            Navigator.of(context).pop();
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error al eliminar')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Borrar'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

