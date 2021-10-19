import 'package:country/domain/country/country.dart';
import 'package:country/ui/screen/country_list_screen/country_list_screen_widget_model.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

/// Widget screen with list of countries.
class CountryListScreen extends WMWidget<ICountryListWidgetModel> {
  const CountryListScreen({
    Key? key,
    WidgetModelFactory wmFactory = countryListScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ICountryListWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список стран'),
      ),
      body: EntityStateNotifierBuilder<Iterable<Country>>(
        listenableEntityState: wm.countryListState,
        loadingBuilder: (_, __) => const Center(
          child: Text('loading'),
        ),
        errorBuilder: (_, __, ___) => const Center(
          child: Text('Error'),
        ),
        builder: (_, countries) {
          if (countries == null || countries.isEmpty) {
            return const _EmptyList();
          }

          return ListView.separated(
            itemBuilder: (_, index) => _CountryWidget(
              data: countries.elementAt(index),
              countryNameStyle: wm.countryNameStyle,
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: countries.length,
          );
        },
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Список пуст'),
    );
  }
}

class _CountryWidget extends StatelessWidget {
  final Country data;
  final TextStyle countryNameStyle;

  const _CountryWidget({
    Key? key,
    required this.data,
    required this.countryNameStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              transform: Matrix4.rotationZ(-0.2)
                ..scale(1.2)
                ..translate(-50.0),
              height: 250,
              width: double.infinity,
              child: Image.network(
                data.flag,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            left: 10,
            child: LayoutBuilder(builder: (context, constraints) {
              return Row(
                children: [
                  const Spacer(),
                  Container(
                    constraints: constraints.copyWith(minWidth: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white70,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.name,
                      style: countryNameStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
