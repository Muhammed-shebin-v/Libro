import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/user_score.dart';
import 'package:libro/features/presentation/bloc/leader_board/leader_board_bloc.dart';
import 'package:libro/features/presentation/bloc/leader_board/leader_board_event.dart';
import 'package:libro/features/presentation/bloc/leader_board/leader_board_state.dart';
import 'package:libro/features/presentation/widgets/container.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              LeaderboardBloc(FirebaseFirestore.instance)
                ..add(FetchLeaderboard()),
      child: Scaffold(
        backgroundColor: AppColors.color60,
        appBar: AppBar(
          backgroundColor: AppColors.color60,
          title: const Text("Leaderboard"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
          child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
            builder: (context, state) {
              if (state is LeaderboardLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LeaderboardLoaded) {
                final users = state.sortedUsers;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTopUser(
                          "Book Worm of ${DateFormat('MMMM').format(DateTime.now())}",
                          users[0],
                        ),
                        _buildTopUser("Book Worm of All Time", users[0]),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Top Scorers",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        // physics:noscrolla,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return _buildUserTile(index, users[index]);
                        },
                        separatorBuilder: (context, index) => Gap(10),
                      ),
                    ),
                  ],
                );
              } else if (state is LeaderboardError) {
                return Center(child: Text("Error: ${state.message}"));
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopUser(String title, UserScore user) {
    return CustomContainer(
      width: 150,
      height: 200,
      color: AppColors.color10,
      radius: BorderRadius.circular(20),
      shadow: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(title, textAlign: TextAlign.center, style: AppFonts.heading4),
            const SizedBox(height: 10),
            CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl),
              radius: 30,
            ),
            const SizedBox(height: 10),
            Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text('${user.score}pts', style: AppFonts.body2),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(int index, UserScore user) {
    return CustomContainer(
      color: AppColors.color30,
      radius: BorderRadius.circular(15),
      shadow: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(
              '${index + 1}.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.imageUrl),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: AppFonts.heading4),
                  Text(user.email, style: AppFonts.body2),
                ],
              ),
            ),
            Row(
              children: [
                Text('${user.score}', style: AppFonts.heading4),
                Text('pts', style: AppFonts.body2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
