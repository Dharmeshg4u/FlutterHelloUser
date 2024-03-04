class Book {
  final String id;
  final String title;
  final String author;

  Book({
    required this.id,
    required this.title,
    required this.author,
  });

  factory Book.fromJson(Map<String, dynamic> json, String id) {
    return Book(
      id: id,
      title: json['Title'] as String,
      author: json['Author'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Author': author,
    };
  }
}