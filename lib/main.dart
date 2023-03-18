import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<Photos> fetchPhotos() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos/1'));

  if (response.statusCode == 200) {
    return Photos.fromJson(jsonDecode(response.body));
  } 

  else {
    throw Exception('Falha para carregar as fotos');
  }
}

class Photos{
  final String albumId;
  final String id;
  final String titulo;
  final String url;
  final String thumbnailUrl;

  Photos({
    required this.albumId,
    required this.id,
    required this.titulo,
    required this.url,
    required this.thumbnailUrl,
  });


  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
      albumId: json['albumId'],
      id: json['id'],
      titulo: json['titulo'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl']
    );
  }
}


void main() => runApp(const MyApp());


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Photos> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePhotos = fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photos (Fotos)',
      theme: ThemeData(
        primarySwatch: Colors.blue),
        home: Scaffold(
        appBar: AppBar(
          title: const Text('Photos (Fotos)'),
        ),
        body: Center(
          child: FutureBuilder<Photos>(
            future: futurePhotos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(snapshot.data!.albumId),
                    Text(snapshot.data!.id),
                    Text(snapshot.data!.titulo),
                    Text(snapshot.data!.url),
                    Text(snapshot.data!.thumbnailUrl)
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          )
        ),
      ),
    );
  }
}