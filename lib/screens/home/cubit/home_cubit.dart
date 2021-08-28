import 'package:deskable/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository;

  HomeCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(HomeState.initial());
}
