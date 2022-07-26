import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_music/cubit/home_cubit.dart';
import 'package:flutter_app_music/music_details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

Widget musicPlayerWidget(context, HomeState state) {
  final _homeCubit = Modular.get<HomeCubit>();
  return InkWell(
    onTap: () {
      Modular.to.push(
        MaterialPageRoute(builder: (ctx) => MusicDetailsScreen()),
      );
    },
    child: Dismissible(
        direction: DismissDirection.startToEnd,
        key: UniqueKey(),
        onDismissed: (direction) async {
          _homeCubit.clearMusicStream();
        },
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 350),
          child: (state.isPlayed || state.isPaused)
              ? Container(
                  margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          // height: 155,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    margin: EdgeInsets.only(left: 10, top: 7),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        state.music?.cover ?? " ",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.only(top: 7, left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.music?.title ?? "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          state.music?.artist ?? "",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: StreamProvider<Duration>(
                                  create: (_) =>
                                      _homeCubit.audioPlayer.positionStream,
                                  initialData: Duration(),
                                  builder: (context, child) {
                                    double sliderValue = (_homeCubit.audioPlayer.duration?.inMilliseconds
                                        .toDouble() ?? 1.toDouble()) <
                                            Provider.of<Duration>(context).inMilliseconds.toDouble()
                                        ? (_homeCubit.audioPlayer.duration?.inMilliseconds.toDouble() ?? 1.toDouble())
                                        : Provider.of<Duration>(context).inMilliseconds.toDouble();


                                    if( _homeCubit.audioPlayer.position == _homeCubit.audioPlayer.duration){
                                      Future.delayed(const Duration(seconds: 1),()async{
                                        await _homeCubit.nextMusic();
                                      });
                                    }
                                    return Column(
                                      children: [
                                        Slider(
                                          activeColor: Colors.blue.shade900,
                                          inactiveColor: Colors.white.withOpacity(0.7),
                                          min: 0,
                                          max: (_homeCubit.audioPlayer.duration?.inMilliseconds.toDouble() ?? 1.toDouble()),
                                          value: sliderValue,
                                          onChanged: (value) async {

                                            await _homeCubit.seekMusic(Duration(milliseconds: value.toInt()));

                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _formatDuration(_homeCubit.audioPlayer.position),
                                                style: TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                _formatDuration(_homeCubit.audioPlayer.duration ?? Duration()),
                                                style: TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10, right: 7),
                                    padding: EdgeInsets.zero,
                                    child: GestureDetector(
                                        onTap: () async {
                                          await _homeCubit.previousMusic();
                                        },
                                        child: Icon(Icons.skip_previous_rounded,
                                            size: 40,
                                            color: Colors.blue.shade900)),
                                  ),
                                  BlocBuilder<HomeCubit, HomeState>(
                                      bloc: _homeCubit,
                                      builder: (context, state) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                              color: Colors.blue.shade900,
                                              shape: BoxShape.circle),
                                          child: StreamProvider<Duration>(
                                            create: (_) => _homeCubit
                                                .audioPlayer.positionStream,
                                            initialData: Duration(),
                                            builder: (context, child) {
                                              double sliderValue = (_homeCubit.audioPlayer.duration?.inMilliseconds.toDouble() ?? 1.toDouble()) <
                                                      Provider.of<Duration>(context).inMilliseconds.toDouble()
                                                  ? (_homeCubit.audioPlayer.duration?.inMilliseconds.toDouble() ?? 1.toDouble())
                                                  : Provider.of<Duration>(context).inMilliseconds.toDouble();
                                              double maxSliderValue = _homeCubit.audioPlayer.duration?.inMilliseconds.toDouble() ?? 1.toDouble();

                                              if (sliderValue ==
                                                  maxSliderValue) {
                                                // if (_homeCubit.state.isPlayed &&
                                                //     onWrapperApp)
                                                //   audioProvider.next();
                                              }
                                              IconData icon = state.isPlayed
                                                  ? Icons.pause_rounded
                                                  : Icons.play_arrow_rounded;

                                              return IconButton(
                                                onPressed: () async {
                                                  if (sliderValue == maxSliderValue) {
                                                    await _homeCubit.seekMusic(Duration());
                                                    return _homeCubit.playMusic();
                                                  }
                                                  // (state.isPlayed
                                                  //     ? _homeCubit.pauseMusic
                                                  //     : _homeCubit.playMusic)();
                                                  if (state.isPlayed) {
                                                    _homeCubit.pauseMusic();
                                                  } else {
                                                    _homeCubit.playMusic();
                                                  }
                                                },
                                                icon: Icon(
                                                  icon,
                                                  color: Colors.white,
                                                  size: 33,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 7, bottom: 10),
                                    padding: EdgeInsets.zero,
                                    child: GestureDetector(
                                        onTap: () async {
                                          await _homeCubit.nextMusic();
                                        },
                                        child: Icon(
                                          Icons.skip_next_rounded,
                                          size: 40,
                                          color: Colors.blue.shade900,
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                )
              : SizedBox(),
        )),
  );
}

String _formatDuration(Duration d) {
  if (d == null) return "--:--";
  int minute = d.inMinutes;
  int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
  String format = ((minute < 10) ? "0$minute" : "$minute") +
      ":" +
      ((second < 10) ? "0$second" : "$second");
  return format;
}
