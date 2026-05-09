import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'models/movie.dart';
import 'services/tmdb_service.dart';
import 'database/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Explorer',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: ChangeNotifierProvider(
        create: (_) => MovieProvider()..loadMovies(),
        child: MovieListScreen(),
      ),
    );
  }
}

class MovieProvider extends ChangeNotifier {
  final TmdbService _tmdbService = TmdbService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Movie> get movies => _filteredMovies.isEmpty ? _movies : _filteredMovies;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadMovies() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _movies = await _dbHelper.getMovies();

      if (_movies.isEmpty) {
        final popularMovies = await _tmdbService.fetchPopularMovies();
        _movies = popularMovies;
        await _dbHelper.insertMovies(_movies);
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchMovies(String query) {
    if (query.isEmpty) {
      _filteredMovies = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _tmdbService
        .searchMovies(query)
        .then((results) {
          _filteredMovies = results;
          _isLoading = false;
          _errorMessage = '';
          notifyListeners();
        })
        .catchError((e) {
          _errorMessage = 'Error en búsqueda: ${e.toString()}';
          _filteredMovies = [];
          _isLoading = false;
          notifyListeners();
        });
  }
}

class MovieListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Explorer'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar película...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) => provider.searchMovies(query),
            ),
          ),
        ),
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(MovieProvider provider) {
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.loadMovies(),
              child: Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (provider.movies.isEmpty) {
      return Center(child: Text('No hay películas'));
    }

    return ListView.builder(
      itemCount: provider.movies.length,
      itemBuilder: (context, index) {
        final movie = provider.movies[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child:
                movie.posterPath != null
                    ? CachedNetworkImage(
                      width: 50,
                      imageUrl:
                          'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      placeholder:
                          (context, url) => SizedBox(
                            width: 50,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                    : Container(width: 50, color: Colors.grey),
          ),
          title: Text(movie.title),
          subtitle: Text('⭐ ${movie.voteAverage.toStringAsFixed(1)}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
        );
      },
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movie.posterPath != null)
              CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                placeholder:
                    (context, url) =>
                        Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 5),
                      Text('${movie.voteAverage.toStringAsFixed(1)} / 10'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sinopsis',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(movie.overview),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
