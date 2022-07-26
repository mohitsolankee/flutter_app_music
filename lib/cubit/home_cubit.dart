import 'package:flutter/cupertino.dart';
import 'package:flutter_app_music/model/Music.dart';
import 'package:flutter_app_music/music_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  AudioPlayer audioPlayer = AudioPlayer();

  HomeCubit() : super(HomeState.initial());

  Future searchMusic(String searchText) async {
    emit(state.copyWith(
      search: await MusicService.searchMusic(searchText),
    ));
  }

  Future playSource(Music music, List<Music>? arrMusic) async {
    audioPlayer.setUrl(music.url);
    audioPlayer.play();

    emit(state.copyWith(
        audioPlayer: audioPlayer,
        isPaused: false,
        isPlayed: true,
        music: music,
        search: arrMusic));
  }

  Future seekMusic(Duration time) async {
    await audioPlayer.seek(time);
  }

  Future playMusic() async {
    emit(state.copyWith(
        audioPlayer: audioPlayer, isPaused: false, isPlayed: true));
    await audioPlayer.play();
  }

  Future pauseMusic() async {
    emit(state.copyWith(
        audioPlayer: audioPlayer, isPaused: true, isPlayed: false));
    await audioPlayer.pause();
  }

  Future nextMusic() async {
    List<int?> listIndexMusic = state.search!
        .asMap()
        .entries
        .map((m) => m.value.id == state.music?.id ? m.key : null)
        .toList()
        .cast<int?>();

    listIndexMusic.removeWhere((element) => element == null);

    Music music = state.search![
        (listIndexMusic.first! + 1) > (state.search!.length - 1)
            ? (listIndexMusic.length - 1)
            : (listIndexMusic.first! + 1)];

    await this.playSource(music, state.search!);
  }

  Future previousMusic() async {
    List<int?> listIndexMusic = state.search!
        .asMap()
        .entries
        .map((m) => m.value.id == state.music?.id ? m.key : null)
        .toList()
        .cast<int?>();

    listIndexMusic.removeWhere((element) => element == null);

    // fetch object from list
    Music music = state.search![
        (listIndexMusic.first! - 1) < 0 ? 0 : (listIndexMusic.first! - 1)];

    await this.playSource(music, state.search!);
  }

  Future clearMusicStream() async {
    audioPlayer.pause();

    emit(state.copyWith(
        audioPlayer: audioPlayer,
        isPaused: false,
        isPlayed: false,
        music: Music(0, "", "", "", "", 0, "")));
  }
}
