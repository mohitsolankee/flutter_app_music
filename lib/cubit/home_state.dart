part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState({
    String? keyword,
    TextEditingController? searchController,
    List<Music>? search,
    @Default(false) bool loadingSearch,
    AudioPlayer? audioPlayer,
    @Default(false) bool isPlayed,
    @Default(false) bool isPaused,
    Music? music,
  }) = _HomeState;

  factory HomeState.initial() => const HomeState(search: []);
}
