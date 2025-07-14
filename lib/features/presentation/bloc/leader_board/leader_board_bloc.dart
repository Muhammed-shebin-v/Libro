import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/data/models/user_score.dart';
import 'package:libro/features/presentation/bloc/leader_board/leader_board_event.dart';
import 'package:libro/features/presentation/bloc/leader_board/leader_board_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final FirebaseFirestore firestore;

  LeaderboardBloc(this.firestore) : super(LeaderboardInitial()) {
    on<FetchLeaderboard>(_onFetchLeaderboard);
  }

  Future<void> _onFetchLeaderboard(
    FetchLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(LeaderboardLoading());
    try {
      final snapshot = await firestore.collection('users').get();
      final users = snapshot.docs.map((doc) {
        return UserScore.fromMap(doc.id, doc.data());
      }).toList();

      users.sort((a, b) => b.score.compareTo(a.score)); 

      emit(LeaderboardLoaded(users));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }
}
