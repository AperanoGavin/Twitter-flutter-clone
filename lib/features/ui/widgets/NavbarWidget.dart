import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/navbar/NavbarBloc.dart';
import '../../blocs/navbar/NavbarState.dart';
import '../../blocs/navbar/NavbarEvent.dart';

class NavbarWidget extends StatelessWidget {
  NavbarWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.currentIndex,
          onTap: (index) {
            context.read<NavBloc>().add(NavItemChanged(index));
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );
      },
    );
  }
}