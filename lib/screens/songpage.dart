import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:media_player_app/global/global.dart';

class SongPage extends StatefulWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  Duration? duration = Duration.zero;

  audioOpen() async {
    await assetsAudioPlayer.open(Audio(Global.currentSong.audio),
        autoStart: false);

    setState(() {
      duration = assetsAudioPlayer.current.value?.audio.duration;
    });
  }

  @override
  void initState() {
    super.initState();
    audioOpen();
  }

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Playing"),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 38),
            Text(
              "${Global.currentSong.songName}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              height: 230,
              width: 230,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: AssetImage(
                      "${Global.currentSong.image}",
                    ),
                    fit: (Global.currentSong.songName! == "L's Theme C")
                        ? BoxFit.fitHeight
                        : BoxFit.cover),
              ),
            ),
            const SizedBox(height: 25),
            StreamBuilder(
                stream: assetsAudioPlayer.currentPosition,
                //Global.currentSong.player.currentPosition,
                builder: (context, AsyncSnapshot snapshot) {
                  Duration currentPosition = snapshot.data;
                  return Column(
                    children: [
                      Text(
                        "${"$currentPosition".split(".")[0]}/ ${"$duration}".split(".")[0]}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Slider(
                        min: 0,
                        max: duration!.inSeconds.toDouble(),
                        value: currentPosition.inSeconds.toDouble(),
                        onChanged: (val) async {
                          await assetsAudioPlayer
                              .seek(Duration(seconds: val.toInt()));
                        },
                      ),
                    ],
                  );
                }),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 38,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  icon: const Icon(Icons.filter_list),
                ),
                IconButton(
                  iconSize: 38,
                  onPressed: () {
                    if (Global.index > 0) {
                      setState(() {
                        assetsAudioPlayer.pause();
                        Global.index--;
                        Global.currentSong = Global.songList![Global.index];
                      });
                      Navigator.of(context).pushReplacementNamed('song_page');
                    }
                  },
                  icon: const Icon(Icons.skip_previous),
                ),
                IconButton(
                  iconSize: 38,
                  onPressed: () async {
                    setState(() {
                      isPlaying = (isPlaying) ? false : true;
                    });
                    (isPlaying)
                        ? await assetsAudioPlayer.play()
                        : await assetsAudioPlayer.pause();
                  },
                  icon: (isPlaying)
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                ),
                IconButton(
                  onPressed: () {
                    if (Global.index < Global.songList!.length - 1) {
                      setState(() {
                        assetsAudioPlayer.pause();
                        Global.index++;
                        Global.currentSong = Global.songList![Global.index];
                      });
                      Navigator.of(context).pushReplacementNamed('song_page');
                    }
                  },
                  icon: const Icon(Icons.skip_next),
                  iconSize: 38,
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      isPlaying = false;
                    });
                    assetsAudioPlayer.stop();
                  },
                  icon: const Icon(Icons.stop),
                  iconSize: 38,
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await assetsAudioPlayer.stop();
  }
}
