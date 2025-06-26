import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  int id;
  String spotifyId;
  String? imageUrl;
  String datoUno; //String name; 
  String? datoDos; //String? releaseDate;
  int? datoTres; //int? totalTracks;
  //List<String>? artists;
  
  

  
  ListScreen(
    {super.key, required this.id, required this.spotifyId, this.imageUrl, required this.datoUno, this.datoDos, this.datoTres}
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black, 
          width: 2
        ),
      ),
      child: Row(
        children: [
          imageUrl != ""
            ? Image.network(imageUrl!)
            : Image.asset('assets/1200px-Spotify.png'),
          //Image.network(imageUrl!),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,        
              children: [ 
                Text(
                  datoUno,
                  style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Text(id.toString())         
        ],
      ),
    );
  }
}











  