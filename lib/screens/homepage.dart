import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global/global.dart';
import '../modal/modal.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  loadJsonData() async {
    String res = await rootBundle.loadString("json/jsonData.json");

    List decodedData = jsonDecode(res);

    setState(() {
      Global.songList = decodedData.map((e) => Song.fromJSON(e)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: Global.songList!.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              setState(() {
                Global.index = i;
                Global.currentSong = Global.songList![i];
              });
              Navigator.of(context).pushNamed('song_page');
            },
            child: Container(
              width: width,
              height: 95,
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0),
                    blurRadius: 5,
                    spreadRadius: 2,
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    height: 90,
                    width: 85,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Global.songList![i].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    Global.songList![i].songName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
