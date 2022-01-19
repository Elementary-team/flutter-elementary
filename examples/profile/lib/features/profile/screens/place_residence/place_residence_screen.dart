import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';
import 'package:profile/assets/strings/place_residence_screen_strings.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen_widget_model.dart';
import 'package:profile/features/profile/widgets/next_button.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Widget screen with users place of residence.
class PlaceResidenceScreen
    extends ElementaryWidget<IPlaceResidenceScreenWidgetModel> {
  /// Create an instance [PlaceResidenceScreen].
  const PlaceResidenceScreen({
    Key? key,
    WidgetModelFactory wmFactory = placeResidenceScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IPlaceResidenceScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PlaceResidenceScreenStrings.placeResidence),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 16.0),
            RawAutocomplete<String>(
              textEditingController: wm.controller,
              focusNode: wm.focusNode,
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return wm.getSuggestion(textEditingValue.text);
              },
              onSelected: (selection) {
                wm.updatePlaceResidence(selection);
              },
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                return Form(
                  key: wm.formKey,
                  child: TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: PlaceResidenceScreenStrings.placeResidence,
                      hintStyle: TextStyle(
                        fontSize: 18.0,
                        color: textFieldBorderColor,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: textFieldBorderColor),
                      ),
                    ),
                    onFieldSubmitted: (_) {
                      onFieldSubmitted();
                      wm.onFieldSubmitted();
                    },
                    validator: wm.placeResidenceValidator,
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: SizedBox(
                      height: 200.0,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                            },
                            child: ListTile(
                              title: Text(option),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 40.0,
              width: double.infinity,
              child: ElevatedButton(
                child:
                    const Text(PlaceResidenceScreenStrings.selectCityOnTheMap),
                onPressed: () {
                  wm.showBottomSheet(
                    builder: (context) => _MapWidget(
                      callback: wm.popMethod,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            NextButton(callback: () {}),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class _MapWidget extends StatelessWidget {
  final VoidCallback callback;
  YandexMapController? controller;

  _MapWidget({required this.callback, this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      child: Column(
        children: [
          const _TopBottomSheetLabel(),
          const SizedBox(height: 16.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: YandexMap(
                onMapCreated: (yandexMapController) async {
                  controller = yandexMapController;
                },
                onMapTap: (_) {},
                onUserLocationAdded: (view) async {
                  return view.copyWith(
                    pin: view.pin.copyWith(
                      icon: PlacemarkIcon.single(
                        PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                            'lib/assets/icons/user.png',
                          ),
                        ),
                      ),
                    ),
                    arrow: view.arrow.copyWith(
                      icon: PlacemarkIcon.single(
                        PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                            'lib/assets/icons/arrow.png',
                          ),
                        ),
                      ),
                    ),
                    accuracyCircle: view.accuracyCircle.copyWith(
                      fillColor: Colors.green.withOpacity(0.5),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(PlaceResidenceScreenStrings.cancel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget - Modal Window Shortcut.
class _TopBottomSheetLabel extends StatelessWidget {
  const _TopBottomSheetLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 16,
      child: Center(
        child: Container(
          width: 30,
          height: 5,
          decoration: const BoxDecoration(
            color: hintColor,
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
          ),
        ),
      ),
    );
  }
}
