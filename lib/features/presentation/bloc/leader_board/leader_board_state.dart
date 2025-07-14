import 'package:libro/features/data/models/user_score.dart';

abstract class LeaderboardState {}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<UserScore> sortedUsers;

  LeaderboardLoaded(this.sortedUsers);
}

class LeaderboardError extends LeaderboardState {
  final String message;
  LeaderboardError(this.message);
}
