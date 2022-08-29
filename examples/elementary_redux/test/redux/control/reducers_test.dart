import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux_elementary_test/model/dog_data.dart';
import 'package:redux_elementary_test/redux/actions/adding_data_action.dart';
import 'package:redux_elementary_test/redux/actions/clearing_all_data_action.dart';
import 'package:redux_elementary_test/redux/actions/request_loading_action.dart';
import 'package:redux_elementary_test/redux/control/dog_data_reducers.dart';
import 'package:redux_elementary_test/redux/store/dogs_state.dart';

void main() {
  group('Reducers test', () {
    late DogsState state;

    setUp(() {
      state = const DogsState();
    });
    test('RequestLoadingAction with empty data sets state with empty data', () {
      state = state.copyWith(dogsList: <DogData>[].lock);
      final newState =
          DogDataReducers.getReducers.call(state, RequestLoadingAction());

      expect(newState.dogsList, isEmpty);
    });

    test('AddingDataAction sets value', () {
      expect(state.dogsList, isEmpty);
      const dog = DogData(message: 'message', status: 'status');

      final newState = DogDataReducers.getReducers.call(
        state,
        const AddingDataAction(dog),
      );

      expect(newState.dogsList.isNotEmpty, isTrue);
    });

    test('ClearingAllDataAction clears filled state', () {
      state = state.copyWith(
          dogsList: [const DogData(message: 'message', status: 'status')].lock);
      expect(state.dogsList, isNotEmpty);

      final newState = DogDataReducers.getReducers.call(
        state,
        const ClearingAllDataAction(),
      );

      expect(newState.dogsList.isEmpty, isTrue);
    });
  });
}
