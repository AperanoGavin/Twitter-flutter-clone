import 'package:flutter_bloc/flutter_bloc.dart';
import 'NavbarEvent.dart';
import 'NavbarState.dart';



class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(NavState(currentIndex: 0)) {
    on<NavItemChanged>((event, emit) {
      emit(NavState(currentIndex: event.index));
    });
  }
}