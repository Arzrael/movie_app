import 'package:flutter/material.dart';
import 'package:movie_app/model.dart';
import 'package:movie_app/movie_detail.dart';
import 'package:movie_app/service.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final TMDBService tmdbService = TMDBService();
  Future<List<Movie>>? futureMovies;
  Future<List<Movie>>? favMovie;
  Future<List<Movie>>? genreMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = tmdbService.fetchMovies();
    favMovie = tmdbService.fetchPopularMovies();
    genreMovies = tmdbService.fetchMovies(); // Default movies list
  }

  int selectedColor = 0;
  int selectedGenre = 0;

  void _fetchMoviesByGenre(int genreId) {
    setState(() {
      selectedGenre = genreId;
      genreMovies = tmdbService.fetchMovieByGenre(selectedGenre);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(115, 36, 35, 35),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black87,
        title: const Text(
          "Movie App",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            // For movies Genre
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  moviesGenre("All", 0),
                  moviesGenre("Action", 28),
                  moviesGenre("Adventure", 12),
                  moviesGenre("Comedy", 35),
                  moviesGenre("Horror", 27),
                  moviesGenre("Romance", 10749),
                  moviesGenre("Animation", 16),
                ],
              ),
            ),

            (selectedGenre == 0)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // For Recent movies
                      const Padding(
                        padding: EdgeInsets.only(top: 8, left: 15),
                        child: Text(
                          "Recent Movies",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          height: 245,
                          child: FutureBuilder<List<Movie>>(
                            future: futureMovies,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No movies found'));
                              } else {
                                return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      Movie movie = snapshot.data![index];
                                      return displayMovieList(movie);
                                    });
                              }
                            },
                          ),
                        ),
                      ),

                      // For Trending movies
                      const Padding(
                        padding: EdgeInsets.only(top: 18, left: 15),
                        child: Text(
                          "Top Movie",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 5),
                        child: SizedBox(
                          height: 245,
                          child: FutureBuilder<List<Movie>>(
                            future: favMovie,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No movies found'));
                              } else {
                                return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      Movie movie = snapshot.data![index];
                                      return displayMovieList(movie);
                                    });
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  )
                : FutureBuilder<List<Movie>>(
                    future: genreMovies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 300.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No movies found'));
                      } else {
                        return GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns
                            childAspectRatio: 0.7, // Adjust as needed
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final movie = snapshot.data![index];
                            return displayMovieList(movie);
                          },
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  GestureDetector displayMovieList(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(
                movie: movie,
              ),
            ));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10.0,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(10.0), // Adjust the radius as needed
              child: Image.network(
                "https://image.tmdb.org/t/p/original/${movie.backdropPath}",
                fit: BoxFit.cover,
                height: 185,
                width: 140,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              textAlign: TextAlign.center,
              movie.title ?? 'No Title',
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 15,
                  color: Colors.amber,
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  movie.voteAverage.toString(),
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding moviesGenre(name, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedColor = index;
          });
          _fetchMoviesByGenre(index);
        },
        child: Chip(
          label: Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor:
              selectedColor == index ? Colors.pink : Colors.black54,
        ),
      ),
    );
  }
}
