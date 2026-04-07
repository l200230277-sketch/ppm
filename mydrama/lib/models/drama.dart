class Drama {
  const Drama({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.genre,
    required this.tags,
    required this.synopsis,
    required this.posterAsset,
    required this.isFavorite,
    required this.isInMyList,
    this.mainCast = const [],
  });

  final String id;
  final String title;
  final int year;
  final double rating;
  final String genre;
  final List<String> tags;
  final String synopsis;
  final String posterAsset;
  final bool isFavorite;
  final bool isInMyList;
  final List<String> mainCast;

  Drama copyWith({
    String? id,
    String? title,
    int? year,
    double? rating,
    String? genre,
    List<String>? tags,
    String? synopsis,
    String? posterAsset,
    bool? isFavorite,
    bool? isInMyList,
    List<String>? mainCast,
  }) {
    return Drama(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      genre: genre ?? this.genre,
      tags: tags ?? this.tags,
      synopsis: synopsis ?? this.synopsis,
      posterAsset: posterAsset ?? this.posterAsset,
      isFavorite: isFavorite ?? this.isFavorite,
      isInMyList: isInMyList ?? this.isInMyList,
      mainCast: mainCast ?? this.mainCast,
    );
  }
}
