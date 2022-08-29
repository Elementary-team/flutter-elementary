import 'package:cached_network_image/cached_network_image.dart';
import 'package:elementary/elementary.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:redux_elementary_test/model/dog_data.dart';
import 'package:redux_elementary_test/screen/main_wm.dart';

class MainScreen extends ElementaryWidget<MainWM> {
  const MainScreen({
    Key? key,
    wmFactory = createWM,
  }) : super(wmFactory, key: key);

  @override
  Widget build(MainWM wm) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Redux with Elementary"),
        actions: [
          IconButton(
            onPressed: wm.clearStore,
            icon: const Icon(Icons.clear_rounded),
          ),
        ],
      ),
      body: ValueListenableBuilder<IList<DogData>?>(
        valueListenable: wm.dogsList,
        builder: (_, dogs, __) => dogs!.isEmpty
            ? const Center(
                child: Text('No Data'),
              )
            : CustomScrollView(
                controller: wm.scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          imageUrl: dogs[index].message,
                          placeholder: (_, __) => const Center(
                            child: Text('Loading...'),
                          ),
                        ),
                      ),
                      childCount: dogs.length,
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: wm.isImageLoading,
        builder: (_, isImageLoading, __) {
          return TextButton(
            style: TextButton.styleFrom(
              backgroundColor: isImageLoading ? Colors.amber : Colors.green,
            ),
            onPressed: isImageLoading ? () {} : wm.onAddPressed,
            child: Text(
              isImageLoading ? '' : 'Add',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
