import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:redux_elementary_test/model/dog_data.dart';
import 'package:redux_elementary_test/model/dog_dto.dart';
import 'package:redux_elementary_test/redux/actions/adding_data_action.dart';
import 'package:redux_elementary_test/redux/actions/catching_error_action.dart';
import 'package:redux_elementary_test/redux/actions/clearing_all_data_action.dart';
import 'package:redux_elementary_test/redux/actions/init_action.dart';
import 'package:redux_elementary_test/redux/actions/request_clear_action.dart';
import 'package:redux_elementary_test/redux/actions/request_init_action.dart';
import 'package:redux_elementary_test/redux/actions/request_loading_action.dart';
import 'package:redux_elementary_test/redux/store/dogs_state.dart';
import 'package:redux_elementary_test/services/client.dart';
import 'package:redux_elementary_test/shared_pref_helper.dart';
import 'package:redux_epics/redux_epics.dart';

class DogDataEpicMiddleware {
  final Client _client;
  final SharedPrefHelper _sharedPrefHelper;

  const DogDataEpicMiddleware(
    this._client,
    this._sharedPrefHelper,
  );

  Epic<DogsState> getEffects() => combineEpics([
        TypedEpic<DogsState, RequestLoadingAction>(_onLoadingCharacter),
        TypedEpic<DogsState, RequestClearAction>(_onClearStore),
        TypedEpic<DogsState, RequestInitAction>(_onInit),
      ]);

  Stream<Object> _onInit(
          Stream<RequestInitAction> action, EpicStore<DogsState> store) =>
      action.asyncExpand((action) async* {
        final listFromSP = await _sharedPrefHelper.get('links');
        final regularList = <DogData>[];

        if (listFromSP != null) {
          for (final element in listFromSP) {
            regularList.add(DogData(message: element, status: ''));
          }
        }

        final iList = IList(regularList);

        yield InitAction(iList);
      });

  Stream<Object> _onClearStore(
          Stream<RequestClearAction> action, EpicStore<DogsState> _) =>
      action.asyncExpand((action) async* {
        _sharedPrefHelper.clear('links');
        yield const ClearingAllDataAction();
      });

  Stream<Object> _onLoadingCharacter(
          Stream<RequestLoadingAction> action, EpicStore<DogsState> _) =>
      action.asyncExpand((action) async* {
        try {
          final response = await _client.getDog();
          if (response != null) {
            final listFromSP = await _sharedPrefHelper.get('links');
            var newList = <String>[];
            if (listFromSP != null) {
              newList = [...listFromSP];
            }

            newList.add(response.message);

            await _sharedPrefHelper.set('links', newList);
            action.complete();

            yield AddingDataAction(response.toModel());
          }
        } on DioError catch (err) {
          action.completeError(err);
          yield CatchingErrorAction(err);
        }
      });
}
