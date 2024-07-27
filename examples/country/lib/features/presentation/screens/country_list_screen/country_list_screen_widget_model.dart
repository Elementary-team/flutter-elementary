import 'dart:async';

import 'package:country/features/business/country/domain/model/country.dart';
import 'package:country/features/presentation/di/app_scope_provider.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen_model.dart';
import 'package:country/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';

/// The default factory for [CountryListScreenWidgetModel].
CountryListScreenWidgetModel countryListScreenWidgetModelFactory(
  BuildContext context,
) {
  final dependencies = AppScopeProvider.of(context);
  return dependencies.createCountryListScreenWidgetModel();
}

/// Default impelmentation of [ICountryListWidgetModel].
class CountryListScreenWidgetModel
    extends WidgetModel<CountryListScreen, CountryListScreenModel>
    implements ICountryListWidgetModel {
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  final _countryListState = EntityStateNotifier<List<Country>>();

  @override
  EntityValueListenable<List<Country>> get countryListState =>
      _countryListState;

  CountryListScreenWidgetModel(
    super.model,
    this._scaffoldMessengerWrapper,
  );

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    unawaited(_loadCountryList());
  }

  @override
  void dispose() {
    _countryListState.dispose();
    
    super.dispose();
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException &&
        (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout)) {
      _scaffoldMessengerWrapper.showSnackBar(context, 'Connection troubles');
    }
  }

  Future<void> _loadCountryList() async {
    final previousData = _countryListState.value.data;
    _countryListState.loading(previousData);

    try {
      final res = await model.loadCountries();
      _countryListState.content(res);
    } on Exception catch (e) {
      _countryListState.error(e, previousData);
    }
  }
}

/// An WidgetModel interface for [CountryListScreen].
abstract interface class ICountryListWidgetModel implements IWidgetModel {
  /// A publisher provides list of countries.
  EntityValueListenable<List<Country>> get countryListState;
}
