import '../../../core/model/user/user.dart';


abstract class ProfilState  {
  const ProfilState();


}

class ProfilInitial extends ProfilState {}

class ProfilLoading extends ProfilState {}

class ProfilLoaded extends ProfilState {
  final User user;

  const ProfilLoaded(this.user);


}

class ProfilError extends ProfilState {
  final String message;

  const ProfilError(this.message);


}
