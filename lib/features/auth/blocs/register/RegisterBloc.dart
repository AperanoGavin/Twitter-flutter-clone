import 'package:flutter_bloc/flutter_bloc.dart';
import 'RegisterEvent.dart';
import 'RegisterState.dart';
import '../../../../core/model/auth/register/RegisterUser.dart';
import '../../../../core/network/endpoints/AuthApi.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthApi _authApi = AuthApi();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final registerUser = RegisterUser(
        username: event.username,
        email: event.email,
        password: event.password,
        avatar: event.avatar?.toString() ?? '',
      );
      await _authApi.register(registerUser);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
