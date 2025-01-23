import 'package:flutter_bloc/flutter_bloc.dart';
import 'LoginEvent.dart';
import 'LoginState.dart';
import '../../../../core/network/endpoints/AuthApi.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthApi _authApi = AuthApi();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final authenticatedUser = await _authApi.login(event.email, event.password);
      emit(LoginSuccess(authenticatedUser.token));
    } catch (e) {
      final eMessage = e.toString();
      //recupère seulement ce qui est dans {}
      final errorMessage = eMessage.substring(eMessage.indexOf('{'), eMessage.indexOf('}') + 1);
      //elever les guillemets et {}
      final errorMessageClean = errorMessage.replaceAll(RegExp(r'[{}"]'), '');
      //afficher tout le rester apres le premier :
      final   errorMessageCleann = errorMessageClean.substring(errorMessageClean.indexOf(':') + 1);
      emit(LoginFailure(errorMessageCleann));
    }
  }
}

