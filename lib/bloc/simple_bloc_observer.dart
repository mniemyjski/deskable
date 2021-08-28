import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    Logger().i('${bloc.runtimeType}\nCurrentState:${change.currentState}\nNextState:${change.nextState}');
  }
}
