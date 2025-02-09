// profil/blocs/profil/profil_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../repositories/userRepository.dart';
import '../../../core/model/user/user.dart';
import 'ProfilEvent.dart';
import 'ProfilState.dart';
import '../../../services/AuthService.dart';


class ProfilBloc extends Bloc<ProfilEvent, ProfilState> {
  final UserRepository userRepository;
  final AuthService authService;
  

  ProfilBloc({
      required this.userRepository ,
      required this.authService
     }) : super(ProfilInitial()) {
    on<LoadProfil>(_onLoadProfil);
    on<UpdateProfil>(_onUpdateProfil);
  }

  Future<void> _onLoadProfil(LoadProfil event, Emitter<ProfilState> emit) async {
    emit(ProfilLoading());
    try {
      final userId = event.userId ?? await authService.getUserId();
      //final userId = await authService.getUserId();
      if (userId == null) throw Exception('User not logged in');
      
      final user = await userRepository.getUserById(userId);
      emit(ProfilLoaded(user));
    } catch (e) {
      emit(ProfilError(e.toString()));
    }
  }

  Future<void> _onUpdateProfil(UpdateProfil event, Emitter<ProfilState> emit) async {
    try {
      emit(ProfilLoading());

      final userId = await authService.getUserId();
        if (userId == null) {
        throw Exception('User ID not found in cache');
      }
      final updatedUser = await userRepository.updateProfile(
        UserUpdate(
          id: userId ,
          username: event.username,
          description: event.description,
          avatar: event.avatar,
        ),
      );
      
    final user = await userRepository.getUserById(userId);
    emit(ProfilLoaded(user));

    //emit(ProfilLoading());
    } catch (e) {
      emit(ProfilError(e.toString()));
      // Recharger les données après une erreur
      final userId = await authService.getUserId();
      if (userId != null) {
        final user = await userRepository.getUserById(userId);
        emit(ProfilLoaded(user));
      }
    }
  }
}