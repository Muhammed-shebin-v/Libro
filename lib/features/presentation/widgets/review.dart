import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/data/models/review_model.dart';
import 'package:libro/features/presentation/bloc/review/review_bloc.dart';

class AddReviewScreen extends StatefulWidget {
  final String bookId;
  final String userId;
  final String userName;
  final String userImage;

  const AddReviewScreen({
    super.key,
    required this.bookId,
    required this.userId,
    required this.userName,
    required this.userImage,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReviewBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text("Add Review")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ReviewBloc, ReviewState>(
            listener: (context, state) {
              if (state is ReviewSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Review added successfully!')),
                );
                Navigator.pop(context);
              } else if (state is ReviewError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _reviewController,
                      maxLines: 5,
                      maxLength: 200,
                      decoration: InputDecoration(
                        labelText: 'Your review',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if( value == null||value.isEmpty){
                          return 'Enter review';
                        }
                        if(value.trim().length<3){
                          return 'enter valid review';
                        }
                        return null;
                      }
                          
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text("Rating: "),
                        for (int i = 1; i <= 5; i++)
                          IconButton(
                            icon: Icon(
                              i <= _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = i.toDouble();
                              });
                            },
                          )
                      ],
                    ),
                    const SizedBox(height: 24),
                    state is ReviewLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final review = ReviewModel(
                                  userId: widget.userId,
                                  userName: widget.userName,
                                  userImage: widget.userImage,
                                  reviewText: _reviewController.text,
                                  rating: _rating,
                                  date: DateTime.now().toString(),
                                );

                                context.read<ReviewBloc>().add(
                                      AddReviewEvent(
                                        bookId: widget.bookId,
                                        review: review,
                                      ),
                                    );
                              }
                            },
                            child: Text("Add Review"),
                          )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
