import 'package:flutter_app_music/home.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../cubit/home_cubit.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [Bind.singleton<HomeCubit>((i) => HomeCubit())];

  List<ModularRoute> get routes =>
      [ChildRoute("/", child: (context, args) => HomeScreen())];
}
