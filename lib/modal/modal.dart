import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:core';

class Song {
  final String songName;
  final String audio;
  final String image;

  Song({
    required this.songName,
    required this.audio,
    required this.image,
  });

  factory Song.fromJSON(Map json) {
    return Song(
      songName: json['songName'],
      audio: json['audio'],
      image: json['image'],
    );
  }
}
