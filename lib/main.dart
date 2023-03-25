import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Photos> fetchPhotos() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos/5'));

  if (response.statusCode == 200) {
    return Photos.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Falha para carregar as fotos');
  }
}

class Photos{
  final int albumId;
  final int id;
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
        titulo: json['title'],
        url: json['url'],
        thumbnailUrl: json['thumbnailUrl']
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: Scaffold(
        appBar: AppBar(title: const Text('Arquivos das Fotos')),
        body: const Center(
          child: DialogExample(),
        ),
      ),
    );
  }
}

class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Nome do usuário'),
          content: TextEx(),
          
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Clique para informações'),
    );
  }
}

class TextEx extends StatelessWidget{
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arquivos das Fotos',
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Arquivos das Fotos:'),
        ),
        body: Center(
          child: FutureBuilder<Photos>(
            future: fetchPhotos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(snapshot.data!.albumId.toString()),
                    Text(snapshot.data!.id.toString()),
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










/*  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arquivos das Fotos',
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Arquivos das Fotos:'),
        ),
        body: Center(
          child: FutureBuilder<Photos>(
            future: futurePhotos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(snapshot.data!.albumId.toString()),
                    Text(snapshot.data!.id.toString()),
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
}*/

