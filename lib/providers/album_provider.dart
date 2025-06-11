import 'package:flutter/material.dart';
import 'package:flutter_front/helpers/album_preference.dart';

class AlbumProvider extends ChangeNotifier {
  Album? _selectedAlbum;

  Album? get selectedAlbum => _selectedAlbum;

  void setSelectedAlbum(Album album) {
    _selectedAlbum = album;
    notifyListeners();
  }

  void clearAlbum() {
    _selectedAlbum = null;
    notifyListeners();
  }
}
