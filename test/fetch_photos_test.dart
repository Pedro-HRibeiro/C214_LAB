import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rest_api/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'fetch_photos_test.mocks.dart';


@GenerateMocks([http.Client])
void main() {
  group('fetchPhotos', () {
    test('Retorna uma lista de Fotos', () async {
    final client = MockClient();

    when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/photos')))
      .thenAnswer((_) async => http.Response(
          '[{"albumId": 1, "id": 1, "title": "mock", "url": "mock", "thumbnailUrl": "mock"}]',
          200));

  expect(await fetchPhotos(client), isA<List<Photos>>());
});
 
  

    test('Gera uma exceção se o servidor retornar um erro', () async {
    final client = MockClient();

    when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/photos/1')))
      .thenAnswer((_) async => http.Response('Internal Server Error', 500));

  expect(() => fetchPhotos(client), throwsException);
});

  });
}


