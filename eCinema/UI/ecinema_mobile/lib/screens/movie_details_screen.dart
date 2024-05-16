import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Show show;
  const MovieDetailsScreen({super.key, required this.show});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie details')),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                child: widget.show.movie!.photo != ""
                    ? fromBase64StringCover(widget.show.movie!.photo!)
                    : const Icon(Icons.photo, size: 40, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 10,
              child: Text(
                widget.show.movie!.title.toString().toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                widget.show.movie!.genres!
                    .map((genre) => genre.genre!.name.toString())
                    .join(', '),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[400],
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(children: [
              const Text(
                'Director: ',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                widget.show.movie!.author.toString(),
                style: TextStyle(fontSize: 15, color: Colors.grey[400]),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(children: [
              const Text(
                'Release year: ',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                widget.show.movie!.releaseYear.toString(),
                style: TextStyle(fontSize: 15, color: Colors.grey[400]),
              ),
              const SizedBox(width: 10),
              const Text(
                'Duration: ',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                '${widget.show.movie!.duration} min',
                style: TextStyle(fontSize: 15, color: Colors.grey[400]),
              ),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              'About Movie',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              widget.show.movie!.description.toString(),
              style: TextStyle(fontSize: 15, color: Colors.grey[400]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(35),
                  backgroundColor: const Color.fromARGB(255, 155, 24, 24),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text("Book tickets"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
