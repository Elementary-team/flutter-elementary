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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _SearchCityLine(
              controller: wm.controller,
              focusNode: wm.focusNode,
              getSuggestion: wm.getSuggestion,
              onSelectedCallback: wm.updatePlaceResidence,
              formKey: wm.formKey,
              onFieldSubmittedCallback: wm.onFieldSubmitted,
              validator: wm.placeResidenceValidator,
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 40.0,
              width: double.infinity,
              child: ElevatedButton(
                child:
                    const Text(PlaceResidenceScreenStrings.selectCityOnTheMap),
                onPressed: () {
                  wm.focusNode.unfocus();
                  wm.showBottomSheet(
                    builder: (context) => _MapWidget(
                      onMapTap: wm.getMockCityByCoordinates,
                      saveCity: wm.saveSelectedCityOnMap,
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
            NextButton(callback: wm.savePlaceInProfile),
          ],
        ),
      ),
    );
  }
}

class _SearchCityLine extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<String> Function(String) getSuggestion;
  final Function(String) onSelectedCallback;
  final GlobalKey<FormState> formKey;
  final VoidCallback onFieldSubmittedCallback;
  final FormFieldValidator<String> validator;

  const _SearchCityLine({
    required this.controller,
    required this.focusNode,
    required this.getSuggestion,
    required this.onSelectedCallback,
    required this.formKey,
    required this.onFieldSubmittedCallback,
    required this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: focusNode,
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return getSuggestion(textEditingValue.text);
      },
      onSelected: onSelectedCallback,
      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        return Form(
          key: formKey,
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
              onFieldSubmittedCallback();
            },
            validator: validator,
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
    );
  }
}

class _MapWidget extends StatefulWidget {
  final Function(Point) onMapTap;
  final VoidCallback saveCity;

  const _MapWidget({
    required this.onMapTap,
    required this.saveCity,
    Key? key,
  }) : super(key: key);

  @override
  State<_MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<_MapWidget> {
  List<MapObject> mapObject = [];
  YandexMapController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const _TopBottomSheetLabel(),
            const SizedBox(height: 16.0),
            Expanded(
              child: YandexMap(
                mapObjects: mapObject,
                onMapCreated: (yandexMapController) async {
                  controller = yandexMapController;
                },
                onMapTap: (point) {
                  widget.onMapTap(point);
                  setState(() {
                    mapObject.add(
                      Placemark(
                        mapId: const MapObjectId('place'),
                        point: point,
                        // icon: PlacemarkIcon.single(
                        //  const PlacemarkIconStyle(
                        //     isFlat: true,
                        //   // image: BitmapDescriptor.fromAssetImage(
                        //   //   'assets/icons/user.png',
                        //   // ),
                        //   ),
                        // ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(PlaceResidenceScreenStrings.cancel),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.saveCity();
                      Navigator.of(context).pop();
                    },
                    child: const Text(PlaceResidenceScreenStrings.ready),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
          ],
        ),
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
