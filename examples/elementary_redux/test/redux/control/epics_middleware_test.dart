import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux_elementary_test/model/dog_dto.dart';
import 'package:redux_elementary_test/redux/actions/adding_data_action.dart';
import 'package:redux_elementary_test/redux/actions/catching_error_action.dart';
import 'package:redux_elementary_test/redux/actions/request_loading_action.dart';
import 'package:redux_elementary_test/redux/control/dog_data_epics_middleware.dart';
import 'package:redux_elementary_test/redux/store/dogs_state.dart';
import 'package:redux_elementary_test/services/client.dart';
import 'package:redux_elementary_test/shared_pref_helper.dart';
import 'package:redux_epics/redux_epics.dart';

class RequestLoadingActionMock extends Mock implements RequestLoadingAction {}

class ClientMock extends Mock implements Client {}

class SharedPrefHelperMock extends Mock implements SharedPrefHelper {}

class EpicStoreMock<DogStore> extends Mock implements EpicStore<DogStore> {
  final DogStore _state;
  EpicStoreMock(this._state) {
    when(() => state).thenReturn(_state);
    when(() => onChange)
        .thenAnswer((_) => StreamController<DogStore>.broadcast().stream);
  }
}

void main() {
  late DogsState state;
  late Epic<DogsState> epics;
  late ClientMock clientMock;
  late SharedPrefHelperMock sharedPrefHelperMock;
  late EpicStoreMock<DogsState> storeMock;

  group('Epics middleware tests', () {
    setUp(() {
      state = const DogsState();
      clientMock = ClientMock();
      sharedPrefHelperMock = SharedPrefHelperMock();

      epics =
          DogDataEpicMiddleware(clientMock, sharedPrefHelperMock).getEffects();

      storeMock = EpicStoreMock(state);

      registerFallbackValue(const DogDTO('', ''));

      when(() => sharedPrefHelperMock.get(any()))
          .thenAnswer((_) => Future.value([]));

      when(() => sharedPrefHelperMock.set(any(), any()))
          .thenAnswer((_) => Future<void>.value());
    });
    group('RequestLoadingAction', () {
      test('calls client method getDog and emits AddingAction', () async {
        final action = RequestLoadingActionMock();

        final resultEvents = epics(
          Stream<Object?>.fromIterable(
            [
              action,
            ],
          ).asBroadcastStream(),
          storeMock,
        );

        when(() => clientMock.getDog())
            .thenAnswer((_) async => const DogDTO('', ''));

        await expectLater(
          resultEvents,
          emitsThrough(
            predicate<AddingDataAction>(
              (x) => x.newDog.message.isEmpty && x.newDog.status.isEmpty,
            ),
          ),
        );

        verify(() => clientMock.getDog());

        verify(action.complete);
      });

      test(
          'calls client method getDog, retrieve error and does not emit AddingAction',
          () async {
        final action = RequestLoadingActionMock();

        final resultEvents = epics(
          Stream<Object?>.fromIterable(
            [action],
          ).asBroadcastStream(),
          storeMock,
        ).asBroadcastStream();

        when(
          () => clientMock.getDog(),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: ''),
          ),
        );
        await Future.wait([
          expectLater(
              resultEvents, neverEmits(const TypeMatcher<AddingDataAction>())),
          expectLater(resultEvents,
              emitsThrough(const TypeMatcher<CatchingErrorAction>())),
        ]);

        verify(
          () => clientMock.getDog(),
        );
        verify(
          () => action.completeError(
            any(),
            any(),
          ),
        );
      });
    });
  });
}
