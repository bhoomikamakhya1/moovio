import 'package:flutter/material.dart';
import '../data/movie_service.dart';
import '../domain/movie.dart';

class MovieListScreen extends StatefulWidget {
  MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final MovieService movieService = MovieService();
  List<Movie> movies = [];
  List<Movie> filteredMovies = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMoreMovies = true;
  final ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchMovies() async {
    if (isLoading || !hasMoreMovies) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<dynamic> movieData = await movieService.getMovies(currentPage);
      if (movieData.isEmpty) {
        setState(() {
          hasMoreMovies = false;
        });
      } else {
        setState(() {
          currentPage++;
          movies.addAll(movieData.map((movie) => Movie.fromJson(movie)).toList());
          filteredMovies = List.from(movies);
        });
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchMovies();
    }
  }

  void _filterMovies() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredMovies = movies.where((movie) {
        return movie.title.toLowerCase().contains(query) ||
            movie.overview!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _navigateToDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message')),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching
          ? AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              filteredMovies = List.from(movies);
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          onChanged: (value) => _filterMovies(),
          decoration: InputDecoration(
            hintText: 'Search movies...',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ],
      )
          : AppBar(
        title: Text('Movies List', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ],
      ),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 8.0,
        radius: Radius.circular(10.0),
        scrollbarOrientation: ScrollbarOrientation.right,
        interactive: true,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: filteredMovies.length + 1,
          itemBuilder: (context, index) {
            if (index == filteredMovies.length) {
              return isLoading
                  ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              )
                  : SizedBox.shrink();
            }

            Movie movie = filteredMovies[index];
            return _buildMovieCard(movie);
          },
        ),
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[200],
            ),
            child: movie.posterPath.isEmpty
                ? Icon(Icons.movie, size: 40)
                : Image.network(
              'https://image.tmdb.org/t/p/w92/${movie.posterPath}',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
            ),
          ),
          title: Text(
            movie.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            movie.overview??'',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => _navigateToDetails(movie),
        ),
      ),
    );
  }
}

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  MovieDetailsScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                movie.backdropPath!.isNotEmpty
                    ? Image.network(
                  'https://image.tmdb.org/t/p/w500/${movie.backdropPath}',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey,
                    child: Icon(Icons.broken_image, size: 50),
                  ),
                )
                    : Container(
                  height: 200,
                  color: Colors.grey,
                  child: Icon(Icons.broken_image, size: 50),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: movie.posterPath.isNotEmpty
                            ? Image.network(
                          'https://image.tmdb.org/t/p/w154/${movie.posterPath}',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey,
                            child: Icon(Icons.broken_image),
                          ),
                        )
                            : Container(
                          color: Colors.grey,
                          child: Icon(Icons.movie, size: 40),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text('Release Date: ${movie.releaseDate}'),
                            SizedBox(height: 4),
                            Text('Rating: ${movie.voteAverage.toStringAsFixed(1)} / 10'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                movie.overview??'',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
