class BookModel {
  final String? uid;
  final String bookName;
  final String bookId;
  final String authorName;
  final String description;
  final String category;
  final int pages;
  final int stocks;
  final String location;
  final List<String> imageUrls;
  final String? borrowDate;
  final String? returnDate;
  final int? fine;
  final int?currentStock;
  

  BookModel({
    required this.bookName,
    required this.bookId,
    required this.authorName,
    required this.description,
    required this.category,
    required this.pages,
    required this.stocks,
    required this.location,
    required this.imageUrls,
     this.borrowDate,
     this.returnDate,
     this.fine,
    this.uid,
    this.currentStock
  });


  factory BookModel.fromMap(Map<String, dynamic> data) {
    return BookModel(
      uid: data['uid']??'',
      bookName: data['bookName'] ?? '',
      bookId: data['bookId'] ?? '',
      authorName: data['authorName'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      pages: data['pages'] ?? 0,
      stocks: data['stocks'] ?? 0,
      location: data['location'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      currentStock: data['currentStock']??''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookname': bookName,
      'bookId': bookId,
      'authorName': authorName,
      'description': description,
      'category': category,
      'pages': pages,
      'stocks': stocks,
      'location': location,
      'imageUrls': imageUrls,
    };
  }
}