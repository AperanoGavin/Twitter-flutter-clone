abstract class NavEvent {}

class NavItemChanged extends NavEvent {
  final int index;
  NavItemChanged(this.index);
}