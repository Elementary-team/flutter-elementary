import 'dart:convert';
import 'dart:io';

import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';

abstract class MockWM extends Mock with Diagnosticable {}

class ListenableStateMock<T> extends Mock implements ListenableState<T> {}

class ListenableEntityStateMock<T> extends Mock
    implements ValueListenable<EntityState<T>> {}

// Реализация подмены http клиента для загрузки Image.network
R provideMockedNetworkImages<R>(R Function() body, {List<int>? imageBytes}) {
  return HttpOverrides.runZoned(
    body,
    createHttpClient: (_) =>
        _createMockImageHttpClient(_, imageBytes ?? _transparentImage),
  );
}

class UriFake extends Fake implements Uri {}

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

MockHttpClient _createMockImageHttpClient(
  SecurityContext? _,
  List<int> imageBytes,
) {
  final client = MockHttpClient();
  final request = MockHttpClientRequest();
  final response = MockHttpClientResponse();
  final headers = MockHttpHeaders();

  when(() => client.getUrl(any()))
      .thenAnswer((_) => Future<HttpClientRequest>.value(request));
  when(() => request.headers).thenReturn(headers);
  when(request.close)
      .thenAnswer((_) => Future<HttpClientResponse>.value(response));
  when(() => response.contentLength).thenReturn(_transparentImage.length);
  when(() => response.statusCode).thenReturn(HttpStatus.ok);
  when(() => response.compressionState)
      .thenReturn(HttpClientResponseCompressionState.notCompressed);
  when(
    () => response.listen(
      any(),
      onError: any(named: 'onError'),
      onDone: any(named: 'onDone'),
      cancelOnError: any(named: 'cancelOnError'),
    ),
  ).thenAnswer(
    (invocation) {
      final onData =
          invocation.positionalArguments[0] as void Function(List<int>);
      final onDone = invocation.namedArguments[#onDone] as void Function();
      final onError = invocation.namedArguments[#onError] as void
          Function(Object, [StackTrace]);
      final cancelOnError = invocation.namedArguments[#cancelOnError] as bool;

      return Stream<List<int>>.fromIterable(<List<int>>[imageBytes]).listen(
        onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError,
      );
    },
  );

  return client;
}

final _transparentImage = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);
