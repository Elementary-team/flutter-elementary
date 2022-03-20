import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';
import 'package:profile/assets/res/icons.dart';
import 'package:profile/assets/strings/place_residence_screen_strings.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen_widget_model.dart';
import 'package:profile/features/profile/screens/place_residence/widgets/field_with_suggestions_widget/field_with_suggestions_widget.dart';
import 'package:profile/features/profile/widgets/cancel_button/cancel_button.dart';
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
        title: const Text(PlaceResidenceScreenStrings.placeResidenceTitle),
        actions: const [
          CancelButton(),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: wm.onTapAnEmptySpace,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Form(
                key: wm.formKey,
                child: FieldWithSuggestionsWidget(
                  controller: wm.controller,
                  validator: wm.placeResidenceValidator,
                  focusNode: wm.focusNode,
                ),
              ),
              const SizedBox(height: 16.0),
              _MapOpenButton(
                focusNode: wm.focusNode,
                showBottomSheet: wm.showBottomSheet,
                getMockCityByCoordinates: wm.getCityByCoordinates,
                updateSelectedCityOnMap: wm.updateSelectedCityOnMap,
              ),
              const SizedBox(height: 16.0),
              NextButton(callback: wm.updatePlace),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapOpenButton extends StatelessWidget {
  final FocusNode focusNode;
  final Function({required WidgetBuilder builder, required ShapeBorder shape})
      showBottomSheet;
  final Function(Point) getMockCityByCoordinates;
  final VoidCallback updateSelectedCityOnMap;

  const _MapOpenButton({
    required this.focusNode,
    required this.showBottomSheet,
    required this.getMockCityByCoordinates,
    required this.updateSelectedCityOnMap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      width: double.infinity,
      child: ElevatedButton(
        child: const Text(PlaceResidenceScreenStrings.selectCityOnTheMapButton),
        onPressed: () {
          focusNode.unfocus();
          showBottomSheet(
            builder: (context) => _BottomSheetWithMapWidget(
              onMapTap: getMockCityByCoordinates,
              saveCity: updateSelectedCityOnMap,
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
    );
  }
}

class _BottomSheetWithMapWidget extends StatelessWidget {
  final Function(Point) onMapTap;
  final VoidCallback saveCity;

  const _BottomSheetWithMapWidget({
    required this.onMapTap,
    required this.saveCity,
    Key? key,
  }) : super(key: key);

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
            _MapWidget(onMapTap: onMapTap),
            const SizedBox(height: 16.0),
            _BottomSheetButton(saveCity: saveCity),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class _MapWidget extends StatefulWidget {
  final Function(Point) onMapTap;

  const _MapWidget({
    required this.onMapTap,
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
    return Expanded(
      child: YandexMap(
        mapObjects: mapObject,
        onMapCreated: (yandexMapController) async {
          controller = yandexMapController;
        },
        onMapTap: _onMapTap,
      ),
    );
  }

  void _onMapTap(Point point) {
    widget.onMapTap(point);
    setState(
      () {
        mapObject.add(
          Placemark(
            mapId: const MapObjectId('place'),
            point: point,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                isFlat: true,
                image: BitmapDescriptor.fromAssetImage(
                  IconsPath.userIconForMAp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BottomSheetButton extends StatelessWidget {
  final VoidCallback saveCity;

  const _BottomSheetButton({
    required this.saveCity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(PlaceResidenceScreenStrings.cancelButton),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              saveCity();
              Navigator.of(context).pop();
            },
            child: const Text(PlaceResidenceScreenStrings.readyButton),
          ),
        ),
      ],
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
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
          ),
        ),
      ),
    );
  }
}
