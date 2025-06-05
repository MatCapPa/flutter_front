class Album {
  final String name;
  final String imageUrl;
  final String releaseDate;
  final int total_tracks;
  final List<String> artists;
  final String id;

  Album({required this.name, required this.imageUrl, required this.releaseDate, required this.total_tracks, required this.artists, required this.id});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
      imageUrl: json['image'],
      releaseDate: json['release_date'],
      total_tracks: json['total_tracks'],
      artists: List<String>.from(json['artists']),
      id: json['id']
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "imageUrl": imageUrl,
    "releaseDate" : releaseDate,
    "total_tracks": total_tracks,
    "artists": artists,
    "id": id

  };

  @override
  String toString() {
    return 'Album(name: $name, imageUrl: $imageUrl, releaseDate : $releaseDate, total_tracks : $total_tracks)';
  }
}