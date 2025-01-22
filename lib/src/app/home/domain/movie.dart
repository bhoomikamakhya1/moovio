class Movie {
  final String title;
  final String? overview;
  final String posterPath;
  final String? backdropPath;  // Define this field
  final String releaseDate;   // Define this field
  final double voteAverage;   // Define this field

  Movie({
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String,
      backdropPath: json['backdrop_path'] as String,  // Ensure this field exists
      releaseDate: json['release_date'] as String,   // Ensure this field exists
      voteAverage: (json['vote_average'] as num).toDouble(),  // Ensure this field exists
    );
  }
}
