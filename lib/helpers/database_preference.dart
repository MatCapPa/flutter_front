class ArtistDB{
  final String name;
  final int id;
  final String spotifyid;

  ArtistDB({
    required this.name,
    required this.id,
    required this.spotifyid
  });

   factory ArtistDB.fromJson(Map<String, dynamic> json) {
    return ArtistDB(
      id: json['id'],
      name: json['nombre'],
      spotifyid: json['SpotifyIdArtist']
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "spotifyid": spotifyid
  };
}

class AlbumDB {
  final int id;
  final String name; 
  final String releaseDate;
  final List<String> artists;
  final String imageUrl;
  final int totalTracks;
  final String spotifyId;

  AlbumDB({
    required this.id,
    required this.name,
    required this.releaseDate,
    required this.artists,
    required this.imageUrl,
    required this.totalTracks,
    required this.spotifyId,
  });

  factory AlbumDB.fromJson(Map<String, dynamic> json) {
    return AlbumDB(
      id: json['id'],
      name: json['name'],
      releaseDate: json['release_date'],
      artists: List<String>.from(json['artists']),
      imageUrl: json['image'],
      totalTracks: json['total_tracks'],
      spotifyId: json['SpotifyIdAlbum'],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "imageUrl": imageUrl,
    "releaseDate" : releaseDate,
    "total_tracks": totalTracks,
    "artists": artists,
    "id": id,
    "spotifyid": spotifyId
  };
}

class TrackDB{
  final String name;
  final int id;
  final String spotifyid;
  final int trackNumber;

  TrackDB({
    required this.name,
    required this.id,
    required this.spotifyid,
    required this.trackNumber
  });

  factory TrackDB.fromJson(Map<String, dynamic> json) {
    return TrackDB(
      id: json['id'],
      name: json['name'],
      spotifyid: json['SpotifyIdTrack'],
      trackNumber: json['track_number']
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "spotifyid": spotifyid,
    "trackNumber": trackNumber
  };
}