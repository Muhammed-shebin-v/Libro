import 'package:flutter/material.dart';
import 'package:libro/core/themes/fonts.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        title: const Text("Leaderboard"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCustomContainer("Book Worm of March", "lib/assets/calcifer.jpg", "John Doe : 1200"),
                _buildCustomContainer("Book Worm of All Time", "lib/assets/calcifer.jpg", "calcifer : 2200"),
              ],
            ),
            const SizedBox(height: 20),


            const Text(
              "March Score",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),


            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return _buildUserTile(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCustomContainer(String title, String imagePath, String subtitle) {
    return Container(
      width: 150,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Image.asset(imagePath, width: 60, height: 60),
          const SizedBox(height: 10),
          Text(subtitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ],
      ),
    );
  }


  Widget _buildUserTile(index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        children: [
          Text((index+1).toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundImage: AssetImage('lib/assets/calcifer.jpg'),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text('alen', style: const TextStyle(fontSize: 16))),
          Text('200', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}