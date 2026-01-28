class ReviewModel {
  final String author;
  final String comment;
  final int rating; // 1–5
  final DateTime date;

  ReviewModel({
    required this.author,
    required this.comment,
    required this.rating,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'author': author,
        'comment': comment,
        'rating': rating,
        'date': date.toIso8601String(),
      };

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      author: json['author'],
      comment: json['comment'],
      rating: json['rating'],
      date: DateTime.parse(json['date']),
    );
  }
}
