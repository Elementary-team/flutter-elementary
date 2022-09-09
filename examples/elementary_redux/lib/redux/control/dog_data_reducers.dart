import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:redux/redux.dart';
import 'package:redux_elementary_test/model/dog_data.dart';
import 'package:redux_elementary_test/redux/actions/adding_data_action.dart';
import 'package:redux_elementary_test/redux/actions/catching_error_action.dart';
import 'package:redux_elementary_test/redux/actions/clearing_all_data_action.dart';
import 'package:redux_elementary_test/redux/actions/init_action.dart';
import 'package:redux_elementary_test/redux/store/dogs_state.dart';

class DogDataReducers {
  static final Reducer<DogsState> getReducers = combineReducers([
    TypedReducer<DogsState, AddingDataAction>(_onAddingAction),
    TypedReducer<DogsState, ClearingAllDataAction>(_onClearAction),
    TypedReducer<DogsState, CatchingErrorAction>(_onError),
    TypedReducer<DogsState, InitAction>(_onInit),
  ]);

  static DogsState _onInit(DogsState state, InitAction action) {
    return state.copyWith(dogsList: action.iList);
  }

  static DogsState _onAddingAction(DogsState state, AddingDataAction action) {
    final dogsList = state.dogsList.add(action.newDog);
    return state.copyWith(dogsList: dogsList);
  }

  static DogsState _onClearAction(
      DogsState state, ClearingAllDataAction action) {
    final list = <DogData>[].lock;

    return state.copyWith(dogsList: list);
  }

  static DogsState _onError(DogsState state, CatchingErrorAction action) {
    return state.copyWith(error: action.error);
  }
}
