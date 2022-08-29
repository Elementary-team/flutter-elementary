import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_elementary_test/model/dog_data.dart';
import 'package:redux_elementary_test/redux/store/dogs_state.dart';

import 'main_model.dart';
import 'main_screen.dart';

class MainWM extends WidgetModel<MainScreen, MainModel> {
  final scrollController = ScrollController();
  final _isImageLoading = ValueNotifier<bool>(false);

  ValueListenable<bool> get isImageLoading => _isImageLoading;

  MainWM(MainModel model) : super(model);

  ValueListenable<IList<DogData>?> get dogsList => model.dogsList;

  @override
  void onErrorHandle(Object error) {
    if (error is DioError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Something went wrong')));
    }

    super.onErrorHandle(error);
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  Future<void> onAddPressed() async {
    _isImageLoading.value = true;
    await model.fetchDog();

    _isImageLoading.value = false;
  }

  Future<void> clearStore() async {
    await model.clearStore();
  }
}

MainWM createWM(BuildContext context) => MainWM(MainModel(
      context.read<Store<DogsState>>(),
    ));
