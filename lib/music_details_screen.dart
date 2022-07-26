import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app_music/constant/const.dart';
import 'package:flutter_app_music/cubit/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

class MusicDetailsScreen extends StatefulWidget {
  const MusicDetailsScreen({Key? key}) : super(key: key);

  @override
  _MusicDetailsScreenState createState() => _MusicDetailsScreenState();
}

class _MusicDetailsScreenState extends State<MusicDetailsScreen> {
  final _homeCubit = Modular.get<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget(){
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.lightBlue.withOpacity(0.1),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration:
                BoxDecoration(color: Colors.lightBlue.withOpacity(0.1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _artistNameWidget(),
                    const SizedBox(
                      height: 45,
                    ),
                    _musicImageWidget(),
                    const SizedBox(
                      height: 25,
                    ),
                    _musicTitleArtistWidget(),
                    const SizedBox(
                      height: 15,
                    ),
                    _musicStreamWidget(),
                    _previousNextPlayPauseWidget(),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _musicTitleArtistWidget() {
    return Column(
      children: [
        Center(
          child: Text(
            _homeCubit.state.music?.title ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Center(
          child: Text(
            _homeCubit.state.music?.artist ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _musicStreamWidget() {
    return StreamProvider<Duration>(
      create: (_) => _homeCubit.audioPlayer.positionStream,
      initialData: Duration(),
      builder: (context, child) {
        double sliderValue =
            (_homeCubit.audioPlayer.duration?.inMilliseconds.toDouble() ??
                        1.toDouble()) <
                    Provider.of<Duration>(context).inMilliseconds.toDouble()
                ? (_homeCubit.audioPlayer.duration?.inMilliseconds.toDouble() ??
                    1.toDouble())
                : Provider.of<Duration>(context).inMilliseconds.toDouble();
        if( _homeCubit.audioPlayer.position == _homeCubit.audioPlayer.duration){
          Future.delayed(const Duration(seconds: 1),()async{
            await _homeCubit.nextMusic();
          });
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Slider(
              activeColor: Colors.blue.shade900,
              inactiveColor: Colors.white.withOpacity(0.7),
              min: 0,
              max:
                  (_homeCubit.audioPlayer.duration?.inMilliseconds.toDouble() ??
                      1.toDouble()),
              value: sliderValue,
              onChanged: (value) async {
                await _homeCubit
                    .seekMusic(Duration(milliseconds: value.toInt()));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Constant.formatDuration(_homeCubit.audioPlayer.position),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    Constant.formatDuration(
                        _homeCubit.audioPlayer.duration ?? Duration()),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _artistNameWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Modular.to.pop();
          },
          child: Icon(
            Icons.keyboard_arrow_down,
            size: 30,
            color: Colors.blue.shade900,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            _homeCubit.state.music?.artist ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _musicImageWidget() {
    return Container(
      height: 300,
      width: double.infinity,
      margin: EdgeInsets.only(left: 10, top: 7),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          _homeCubit.state.music?.cover ?? " ",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _previousNextPlayPauseWidget() {
    return Row(
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
                  size: 40, color: Colors.blue.shade900)),
        ),
        BlocBuilder<HomeCubit, HomeState>(
            bloc: _homeCubit,
            builder: (context, state) {
              return Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: Colors.blue.shade900, shape: BoxShape.circle),
                child: StreamProvider<Duration>(
                  create: (_) => _homeCubit.audioPlayer.positionStream,
                  initialData: Duration(),
                  builder: (context, child) {
                    double sliderValue = (_homeCubit
                                    .audioPlayer.duration?.inMilliseconds
                                    .toDouble() ??
                                1.toDouble()) <
                            Provider.of<Duration>(context)
                                .inMilliseconds
                                .toDouble()
                        ? (_homeCubit.audioPlayer.duration?.inMilliseconds
                                .toDouble() ??
                            1.toDouble())
                        : Provider.of<Duration>(context)
                            .inMilliseconds
                            .toDouble();
                    double maxSliderValue = _homeCubit
                            .audioPlayer.duration?.inMilliseconds
                            .toDouble() ??
                        1.toDouble();

                    IconData icon = state.isPlayed
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded;

                    return IconButton(
                      onPressed: () async {
                        if (sliderValue == maxSliderValue) {
                          await _homeCubit.seekMusic(Duration());
                          return _homeCubit.playMusic();
                        }

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
          margin: EdgeInsets.only(left: 7, bottom: 10),
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
    );
  }
}


