import 'package:flutter/material.dart';
import 'package:flutter_front/helpers/database_preference.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlbumDBProvider extends ChangeNotifier {
  AlbumDB? _selectedAlbum;

  AlbumDB? get selectedAlbum => _selectedAlbum;

  void setSelectedAlbumDB(AlbumDB album) {
    _selectedAlbum = album;
    notifyListeners();
  }

  void clearAlbumDB() {
    _selectedAlbum = null;
    notifyListeners();
  }

  Future<void> actualizarAlbumDB(int id, String name, String fecha, int cantPistas) async {
    if (_selectedAlbum == null) return;

    final response = await http.put(
      Uri.parse('https://nodejs-back-6tqt.onrender.com/db/albums/$id'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'apikeyutntup2025',
      },
      body: jsonEncode({
        'name': name,
        'release_date': fecha,
        'total_tracks': cantPistas,
      }),
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');
      throw Exception('Error al actualizar _selectedAlbum');
    }
  }

  Future<void> borrarAlbumDB(int id) async {
    if (_selectedAlbum == null) return;

    final response = await http.delete(
      Uri.parse('https://nodejs-back-6tqt.onrender.com/db/albums/$id'),
      headers: {'x-api-key': 'apikeyutntup2025',},
    );

    if (response.statusCode == 200) {
      _selectedAlbum = null;
      notifyListeners();
    } else {
      throw Exception('Error al eliminar la _selectedAlbum');
    }
  }
}

class ArtistDBProvider extends ChangeNotifier{
  ArtistDB? _selectedArtist;

  ArtistDB? get selectedArtist => _selectedArtist;

  void setSelectedArtistDB(ArtistDB artist) {
    _selectedArtist = artist;
    notifyListeners();
  }

  void clearArtistDB() {
    _selectedArtist = null;
    notifyListeners();
  }

  Future<void> actualizarArtistDB(int id, String nombre) async {
    if (_selectedArtist == null) return;

    final response = await http.put(
      Uri.parse('https://nodejs-back-6tqt.onrender.com/db/artists/$id'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'apikeyutntup2025',
      },
      body: jsonEncode({ 
        'nombre': nombre,
      }),
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');
      throw Exception('Error al actualizar _selectedArtist');
    }
  }

  Future<void> borrarArtistDB(int id) async {
    if (_selectedArtist == null) return;

    final response = await http.delete(
      Uri.parse('https://nodejs-back-6tqt.onrender.com/db/artists/$id'),
      headers: {'x-api-key': 'apikeyutntup2025',},
    );

    if (response.statusCode == 200) {
      _selectedArtist = null;
      notifyListeners();
    } else {
      throw Exception('Error al eliminar la _selectedArtist');
    }
  }
}

class TrackDBProvider extends ChangeNotifier{
  TrackDB? _selectedTrack;

  TrackDB? get selectedTrack => _selectedTrack;

  void setSelectedTrackDB(TrackDB track) {
    _selectedTrack = track;
    notifyListeners();
  }

  void clearTrackDB() {
    _selectedTrack = null;
    notifyListeners();
  }

  Future<void> actualizarTrackDB(int id, String name, int number) async {
    if (_selectedTrack == null) return;

    final response = await http.put(
      Uri.parse('https://nodejs-back-6tqt.onrender.com/db/tracks/$id'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'apikeyutntup2025',
      },
      body: jsonEncode({
        'name': name,
        'track_number': number,
      }),
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');
      throw Exception('Error al actualizar _selectedTrack');
    }
  }

  Future<void> borrarTrackDB(int id) async {
    if (_selectedTrack == null) return;

    final response = await http.delete(
      Uri.parse('https://nodejs-back-6tqt.onrender.com/db/tracks/$id'),
      headers: {'x-api-key': 'apikeyutntup2025',},
    );

    if (response.statusCode == 200) {
      _selectedTrack = null;
      notifyListeners();
    } else {
      throw Exception('Error al eliminar la _selectedTrack');
    }
  }
}