import 'package:flutter_app_music/model/Music.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// music service file
class MusicService {
  static Future<List<Music>> searchMusic(String strKeyWord) async {
    strKeyWord = strKeyWord.replaceAll(' ', '+').toLowerCase();
    Uri url = Uri.parse(
        "https://itunes.apple.com/search?term=$strKeyWord&entity=musicTrack");
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      Map musics = json.decode(response.body);
      return List<Map>.from(musics['results']).map((e) {
        return Music(
            e['trackId'],
            e['artistName'],
            e['artworkUrl100'],
            e['previewUrl'],
            e['trackName'],
            e['trackTimeMillis'],
            e['artistViewUrl']);
      }).toList();
    }
    return [];
  }
}
