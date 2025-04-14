import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/presentation/bloc/bottom_navigation/bottom_navigtion_event.dart';
import 'package:libro/features/presentation/bloc/bottom_navigation/bottom_navigtion_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavState(0)) {
    on<TabChanged>((event, emit) => emit(BottomNavState(event.index)));
  }
}