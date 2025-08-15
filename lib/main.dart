import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_front/helpers/preferences.dart';
import 'package:flutter_front/providers/album_provider.dart';
import 'package:flutter_front/providers/database_provider.dart';
import 'package:flutter_front/providers/theme_provider.dart';
import 'package:flutter_front/screens/screens.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Preferences.initShared();
  
  await dotenv.load(fileName: ".env");

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(isDarkMode: Preferences.darkmode),
      ),
       ChangeNotifierProvider(create: (_) => AlbumProvider()),
       ChangeNotifierProvider(create: (_) => AlbumDBProvider()),
       ChangeNotifierProvider(create: (_) => ArtistDBProvider()),
       ChangeNotifierProvider(create: (_) => TrackDBProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<ThemeProvider>(context, listen: true);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'albums',
        theme: tema.temaActual,
        routes: {
          'home': (context) => const HomeScreen(),
          'albums': (context) => const AlbumsScreen(),
          'album_tracks': (context) => const AlbumTracksScreen(),
          'album_show': (context) => const AlbumsShowScreen(),
          'album_database_screen': (context) => const AlbumDatabaseScreen(),
          'artist_show': (context) => const ArtistsShowScreen(),
          "artist_database_screen":(context) => const ArtistDatabaseScreen(),
          'track_show': (context) => const TracksShowScreen(),
          "track_database_screen":(context) => const TrackDatabaseScreen(),
        }
      );
  }
}