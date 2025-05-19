import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
abstract class CarouselEvent {}

class NextPageEvent extends CarouselEvent {}

class PreviousPageEvent extends CarouselEvent {}

class JumpToPageEvent extends CarouselEvent {
  final int page;
  JumpToPageEvent(this.page);
}

// carousel_state.dart
class CarouselState {
  final int currentPage;
  final int totalPages;

  CarouselState({required this.currentPage, required this.totalPages});

  CarouselState copyWith({int? currentPage, int? totalPages}) {
    return CarouselState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

// carousel_bloc.dart


class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  CarouselBloc({required int totalPages}) 
      : super(CarouselState(currentPage: 0, totalPages: totalPages)) {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
    on<JumpToPageEvent>(_onJumpToPage);
  }

  void _onNextPage(NextPageEvent event, Emitter<CarouselState> emit) {
    if (state.currentPage < state.totalPages - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void _onPreviousPage(PreviousPageEvent event, Emitter<CarouselState> emit) {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void _onJumpToPage(JumpToPageEvent event, Emitter<CarouselState> emit) {
    if (event.page >= 0 && event.page < state.totalPages) {
      emit(state.copyWith(currentPage: event.page));
    }
  }
}

// Now, let's create the UI components

// carousel_widget.dart


class CarouselWidget extends StatefulWidget {
  final List<Widget> items;
  
  const CarouselWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late PageController _pageController;
  late CarouselBloc _carouselBloc;

  @override
  void initState() {
    super.initState();
    // Set viewportFraction to 1.0 to ensure only one item is visible at a time
    _pageController = PageController(initialPage: 0, viewportFraction: 1.0);
    _carouselBloc = CarouselBloc(totalPages: widget.items.length);

    // Listen to bloc state changes to update the page controller
    _carouselBloc.stream.listen((state) {
      if (_pageController.page?.round() != state.currentPage) {
        _pageController.animateToPage(
          state.currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _carouselBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _carouselBloc,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              // Set physics to ensure precise page snapping
              physics: const ClampingScrollPhysics(),
              // Disable page snapping to prevent partial views
              pageSnapping: true,
              // Explicitly set viewportFraction to 1.0 to ensure only one item visible
              
              padEnds: false,
              onPageChanged: (index) {
                // Update the bloc state when page changes
                _carouselBloc.add(JumpToPageEvent(index));
              },
              itemBuilder: (context, index) {
                return widget.items[index];
              },
            ),
          ),
          BlocBuilder<CarouselBloc, CarouselState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.totalPages,
                    (index) => _buildIndicator(context, index == state.currentPage),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, bool isActive) {
    return GestureDetector(
      onTap: () {
        _carouselBloc.add(JumpToPageEvent(isActive ? 0 : 1));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: 8.0,
        width: 8.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade300,
        ),
      ),
    );
  }
}

// main.dart example usage




class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example items for the carousel
    final List<Widget> carouselItems = [
      _buildCarouselItem(Colors.red, "Item 1"),
      _buildCarouselItem(Colors.blue, "Item 2"),
      _buildCarouselItem(Colors.green, "Item 3"),
      _buildCarouselItem(Colors.orange, "Item 4"),
      _buildCarouselItem(Colors.purple, "Item 5"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Carousel Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselWidget(items: carouselItems),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}