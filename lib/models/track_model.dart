import 'dart:convert';

import 'package:flutter_front/helpers/tracks_preference.dart';

List<Tracks> trackFromJson(String str) {
  final jsonData = json.decode(str); // Decodifica el JSON a un Map
  final items = jsonData['data'] as List; // Extrae la lista de 'items'
  return items.map((item) => Tracks.fromJson(item as Map<String, dynamic>)).toList();
}