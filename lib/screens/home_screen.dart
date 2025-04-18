import 'package:flutter/material.dart';
import 'package:flutter_front/widgets/drawer_menu.dart';
import 'package:flutter_front/helpers/preferences.dart';
import 'package:flutter_front/providers/theme_provider.dart';
import 'package:flutter_front/widgets/spotify_appbar.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpotifyAppBar(),
      drawer: DrawerMenu(),
      body: const Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: DarkModeSwitchButton(),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Image(
                image: AssetImage('assets/1200px-Spotify.png'),
                width: 400,
                height: 400,
              ),
            ),
          ],
       )
      ),
    );
  }
}

class DarkModeSwitchButton extends StatefulWidget {
  const DarkModeSwitchButton({super.key});

  @override
  State<DarkModeSwitchButton> createState() => _BodyProfileState();
}

class _BodyProfileState extends State<DarkModeSwitchButton> {
  @override
  Widget build(BuildContext context) {
    final temaProvider = Provider.of<ThemeProvider>(context, listen: false);
    print(Preferences.darkmode);
    return Column(
      children: [
        SwitchListTile.adaptive(
          title: const Text('Dark Mode'),
          value: Preferences.darkmode,
          onChanged: (bool value) {
            setState(() {
              Preferences.darkmode = value;
              value ? temaProvider.setDark() : temaProvider.setLight();
            });
          },
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }


  
}
