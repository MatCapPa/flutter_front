import 'package:flutter/material.dart';
import 'package:flutter_front/providers/database_provider.dart';
import 'package:provider/provider.dart';

class ArtistDatabaseScreen extends StatefulWidget {
  const ArtistDatabaseScreen({super.key});

  @override
  State<ArtistDatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<ArtistDatabaseScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<ArtistDBProvider>(context);
    final artist = Provider.of<ArtistDBProvider>(context).selectedArtist;
    if (artist == null) {
      return const Scaffold(
        body: Center(child: Text('No se ha seleccionado ningún artista')),
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
                  child: Image.asset('assets/1200px-Spotify.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text('Spotify Id: ${artist.spotifyid} Id: ${artist.id}'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final name = _nameController.text.trim();
                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('El nombre no puede estar vacío')),
                            );
                            return;
                          }
                          try {
                            await provider.actualizarArtistDB(artist.id,name);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Datos actualizados')),
                            );
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error al actualizar')),
                            );
                          }
                        },
                        child: const Text('Guardar'),
                      ),
                      const SizedBox(width: 16,),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await provider.borrarArtistDB(artist.id);
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

