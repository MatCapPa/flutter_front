class Tracks{
  final String name;
  final String id;
  final int track_number;

  Tracks({required this.name, required this.id, required this.track_number});

  factory Tracks.fromJson(Map<String, dynamic> json) {
    return Tracks(
      name: json['name'],
      id: json['id'],
      track_number: json['track_number']
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "track_number": track_number

  };

  @override
  String toString() {
    return 'Tracks(name: $name, id: $id, track_number: $track_number)';
  }

}