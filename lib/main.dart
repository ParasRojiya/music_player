import 'package:flutter/material.dart';
import 'package:media_player_app/screens/homepage.dart';
import 'package:media_player_app/screens/songpage.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MyApp(),
        'song_page': (context) => const SongPage(),
      },
    ),
  );
}
