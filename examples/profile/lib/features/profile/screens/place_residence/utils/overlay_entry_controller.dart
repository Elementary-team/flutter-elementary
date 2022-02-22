import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/strings/place_residence_screen_strings.dart';
import 'package:profile/features/profile/widgets/error_widget.dart';

/// Controller to update [Overlay].
class OverlayEntryController {
  /// Create an instance [OverlayEntryController].
  const OverlayEntryController();

  /// Create [OverlayEntry].
  OverlayEntry createOverlayEntry(
    ListenableState<EntityState<List<String>>> listSuggestionsState,
    Function(String) onSelected,
    LayerLink link,
  ) {
    return OverlayEntry(
      builder: (_) {
        return _SuggestionWidget(
          listSuggestionsState: listSuggestionsState,
          onSelected: onSelected,
          layerLink: link,
        );
      },
    );
  }
}

class _SuggestionWidget extends StatelessWidget {
  final ListenableState<EntityState<List<String>>> listSuggestionsState;
  final Function(String) onSelected;
  final LayerLink layerLink;

  const _SuggestionWidget({
    required this.listSuggestionsState,
    required this.onSelected,
    required this.layerLink,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CompositedTransformFollower(
        targetAnchor: Alignment.bottomLeft,
        link: layerLink,
        child: Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: EntityStateNotifierBuilder<List<String>>(
                listenableEntityState: listSuggestionsState,
                builder: (_, listCities) {
                  if (listCities != null && listCities.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: listCities.length,
                      itemBuilder: (context, index) {
                        final option = listCities.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(
                            title: Text(option),
                          ),
                        );
                      },
                    );
                  } else {
                    return const CustomErrorWidget(
                      error: PlaceResidenceScreenStrings.cityNotFoundError,
                    );
                  }
                },
                loadingBuilder: (_, __) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder: (_, __, ___) {
                  return const CustomErrorWidget(
                    error: PlaceResidenceScreenStrings.errorLoading,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
