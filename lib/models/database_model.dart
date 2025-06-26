import 'dart:convert';
import 'package:flutter_front/helpers/database_preference.dart';

List<AlbumDB> databaseAlbumFromJson(String str) {
  final decoded = jsonDecode(str);
  final List<dynamic> rawAlbums = decoded['data']['array'];
  return rawAlbums.map((json) => AlbumDB.fromJson(json)).toList();
}

List<ArtistDB> databaseArtistFromJson(String str) {
  final decoded = jsonDecode(str);
  final List<dynamic> rawArtist = decoded['data']['array'];
  return rawArtist.map((json) => ArtistDB.fromJson(json)).toList();
}

List<TrackDB> databaseTrackFromJson(String str) {
  final decoded = jsonDecode(str);
  final List<dynamic> rawTrack = decoded['data']['array'];
  return rawTrack.map((json) => TrackDB.fromJson(json)).toList();
}
