import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:redux_elementary_test/model/dog_data.dart';

@immutable
class InitAction {
  final IList<DogData> iList;
  const InitAction(this.iList);
}
