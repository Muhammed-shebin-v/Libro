import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/presentation/screens/qr_scanner.dart';
import 'package:libro/features/presentation/screens/settings.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/container.dart';
import 'package:libro/features/presentation/widgets/view_all.dart';

class User extends StatelessWidget {
  User({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF4DC),
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        leading: Image(image: AssetImage('lib/assets/IMG_0899 2.JPG')),
        leadingWidth: 40,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> QrScanner()));
          }, icon: Icon(Icons.qr_code)),
          Gap(20),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Settings()));
          }, icon: Icon(Icons.more_vert_outlined)),
          Gap(20),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey,
                                offset: Offset(4, 4),
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage('lib/assets/calcifer.jpg'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Sarah John', style: AppFonts.heading1),
                              Text('12 Books Borrowed', style: AppFonts.body2),
                              Gap(5),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.color10,
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(offset: Offset(1, 1))],
                                ),
                                width: 90,
                                child: Text(
                                  'score 1200',
                                  textAlign: TextAlign.center,
                                  style: AppFonts.body2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(30),
                    viewAll(context),
                    Gap(5),
                    Container(
                      height: 100,
                      padding: EdgeInsets.only(left: 30),
                      decoration: BoxDecoration(
                        
                        color: AppColors.color10,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(offset: Offset(4, 4))],
                      
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return Gap(20);
                          },
                          itemCount: 3,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 5,
                              ),
                              child: Image(
                                image: AssetImage('lib/assets/badge.png'),
                                width: 50,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(40),
              SizedBox(
                height: 800,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: CustomContainer(
                        color: AppColors.color30,
                        radius: BorderRadius.only(
                          topRight: Radius.circular(25),
                        ),
                        shadow: 4,
                        height: 800,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30,left: 20),
                              child: BooksList(
                                title: 'Borrowed Books',
                                books: books,
                                images: images,
                                authors: authors,
                                gonores: gonores,
                                // colors: colors,
                              ),
                            ),
                             Padding(
                              padding: const EdgeInsets.only(top: 30,left: 20),
                              child: BooksList(
                                title: 'Borrowed Books',
                                books: books,
                                images: images,
                                authors: authors,
                                gonores: gonores,
                                // colors: colors,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 580,
                      right: 0,
                      child: CustomContainer(
                        color: AppColors.color60,
                        radius: BorderRadius.only(topLeft: Radius.circular(25)),
                        shadow: -4,
                        height: 220,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Center(child: Text('Graph')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<String> categories = [
    'Politics',
    'Sports',
    'Technology',
    'Science',
  ];
  final List<String> books = [
    'The Design of Books',
    'My Book cover',
    'A Teaspoon Earth',
    'The Graphic Design Bible',
    'The Way of the Nameless',
  ];
  final List<String> images = [
    'lib/assets/images.png',
    'lib/assets/book-covers-big-2019101610.jpg',
    'lib/assets/images.jpeg',
    'lib/assets/71ng-giA8bL._AC_UF1000,1000_QL80_.jpg',
    'lib/assets/teal-and-orange-fantasy-book-cover-design-template-056106feb952bdfb7bfd16b4f9325c11.jpg',
  ];
  final List<String> authors = [
    'Bebble Benze',
    'My name',
    'Dina Nayeri',
    'Theio Iglis',
    'Graham Douglass ',
  ];
  final List<String> gonores = [
    'Architecture',
    'History',
    'Biodata',
    'Novel',
    'Fictional',
  ];
  final colors = [
    Colors.red,
    const Color.fromARGB(255, 238, 70, 41),
    const Color.fromARGB(255, 10, 167, 195),
    const Color.fromARGB(255, 248, 108, 53),
    const Color.fromARGB(255, 216, 112, 181),
  ];
}
