import 'package:flutter/material.dart';
import 'package:redux_elementary_test/model/dog_data.dart';

@immutable
class AddingDataAction {
  final DogData newDog;

  const AddingDataAction(this.newDog);
}
