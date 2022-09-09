import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:redux_elementary_test/model/dog_data.dart';
import 'package:redux_elementary_test/redux/actions/request_clear_action.dart';
import 'package:redux_elementary_test/redux/actions/request_init_action.dart';
import 'package:redux_elementary_test/redux/actions/request_loading_action.dart';
import 'package:redux_elementary_test/redux/store/dogs_state.dart';

class MainModel extends ElementaryModel {
  final Store<DogsState> _store;

  late final StreamSubscription<DogsState> _storeSubscription;

  final _dogsList = ValueNotifier<IList<DogData>?>(null);

  ValueListenable<IList<DogData>?> get dogsList => _dogsList;

  MainModel(
    this._store,
  );

  @override
  void init() {
    super.init();

    _initStore();

    _dogsList.value = _store.state.dogsList;

    _storeSubscription = _store.onChange.listen(_storeListener);
  }

  @override
  void dispose() {
    _storeSubscription.cancel();

    super.dispose();
  }

  Future<void> fetchDog() async {
    final action = RequestLoadingAction();

    _store.dispatch(action);

    return await action.future;
  }

  Future<void> clearStore() async {
    _store.dispatch(const RequestClearAction());
  }

  Future<void> _initStore() async {
    _store.dispatch(const RequestInitAction());
  }

  void _storeListener(DogsState store) {
    _dogsList.value = store.dogsList;
    final error = store.error;

    if (error != null) {
      handleError(error);
    }
  }
}
