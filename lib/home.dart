import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_music/cubit/home_cubit.dart';
import 'package:flutter_app_music/model/Music.dart';
import 'package:flutter_app_music/widget/music_bottom_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

/*
Flutter modular and cubit based Music Demo App
 */
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _homeCubit = Modular.get<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(
          "Flutter Music",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: _bodyWidget(),
    );
  }

  /// body widget
  Widget _bodyWidget(){
    return BlocBuilder<HomeCubit, HomeState>(
        bloc: _homeCubit..searchMusic("bollywood"),
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state.search?.length != 0
                  ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.search?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _musicListWidget(context,
                            state.search?[index], state.search);
                      }),
                ),
              )
                  : SizedBox.shrink(),
              musicPlayerWidget(context, state),
            ],
          );
        });
  }

  // music list widget
  Widget _musicListWidget(
      BuildContext context, Music? music, List<Music>? arrMusic) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(right: 6),
            width: 45,
            height: 45,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                music?.cover ?? " ",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
              child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 3),
                  child: Text(
                    music?.title ?? "",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  music?.artist ?? "",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          )),
          IconButton(
              onPressed: () async {
                _homeCubit.playSource(music!, arrMusic);
              },
              icon: Icon(
                _homeCubit.state.music?.id == music?.id
                    ? Icons.music_note_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.blue.shade900,
                size: 34,
              )),
        ],
      ),
    );
  }
}
