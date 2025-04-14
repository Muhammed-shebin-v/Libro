abstract class BottomNavEvent {}
class TabChanged extends BottomNavEvent {
  final int index;
  TabChanged(this.index);
}