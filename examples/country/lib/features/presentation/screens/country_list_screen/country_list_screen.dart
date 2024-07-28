import 'package:country/features/business/country/domain/model/country.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen_widget_model.dart';
import 'package:country/utils/widgets/shimmer.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';

/// Widget screen with list of countries.
class CountryListScreen extends ElementaryWidget<ICountryListWidgetModel> {
  const CountryListScreen({
    Key? key,
    WidgetModelFactory wmFactory = countryListScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ICountryListWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country list'),
      ),
      body: EntityStateNotifierBuilder<Iterable<Country>>(
        listenableEntityState: wm.countryListState,
        loadingBuilder: (_, __) => const _LoadingWidget(),
        errorBuilder: (_, __, ___) => const _ErrorWidget(),
        builder: (_, countries) => _CountryList(
          countries: countries,
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Something went wrong'),
    );
  }
}

class _CountryList extends StatelessWidget {
  final Iterable<Country>? countries;

  const _CountryList({
    required this.countries,
  });

  @override
  Widget build(BuildContext context) {
    final countries = this.countries;

    if (countries == null || countries.isEmpty) {
      return const _EmptyList();
    }

    return ListView.separated(
      itemBuilder: (_, index) => _CountryWidget(
        data: countries.elementAt(index),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: countries.length,
      cacheExtent: 800,
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No countries fetched'),
    );
  }
}

class _CountryWidget extends StatelessWidget {
  final Country data;

  const _CountryWidget({
    required this.data,
  });

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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return ShimmerWrapper(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (_, __, ___) {
                  return const Center(child: Icon(Icons.error));
                },
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            left: 10,
            child: LayoutBuilder(
              builder: (context, constraints) {
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
                      child: _CountryName(data: data),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryName extends StatelessWidget {
  const _CountryName({
    required this.data,
  });

  final Country data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data.name,
      style: Theme.of(context).textTheme.titleMedium,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
