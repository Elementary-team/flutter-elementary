import 'package:flutter/material.dart';

/// Widget which rebuild when anyone of the listeners
/// in the [listenerList] changed.
class MultiListenerRebuilder extends StatefulWidget {
  /// A collection of Listenable elements whose changes are to be listened for.
  final Iterable<Listenable> listenerList;

  /// Builder which build a widget when any listened get update.
  final Widget Function(BuildContext context) builder;

  /// Create an instance of [MultiListenerRebuilder]
  const MultiListenerRebuilder({
    Key? key,
    required this.listenerList,
    required this.builder,
  }) : super(key: key);

  @override
  _MultiListenerRebuilderState createState() => _MultiListenerRebuilderState();
}

class _MultiListenerRebuilderState extends State<MultiListenerRebuilder> {
  @override
  void initState() {
    super.initState();

    for (final listener in widget.listenerList) {
      listener.addListener(_markRebuild);
    }
  }

  @override
  void didUpdateWidget(covariant MultiListenerRebuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newList = widget.listenerList;
    final oldList = oldWidget.listenerList;
    if (!identical(newList, oldList)) {
      for (final listener in oldList) {
        if (!newList.contains(listener)) {
          listener.removeListener(_markRebuild);
        }
      }

      for (final listener in newList) {
        if (!oldList.contains(listener)) {
          listener.addListener(_markRebuild);
        }
      }
    }
  }

  @override
  void dispose() {
    for (final listener in widget.listenerList) {
      listener.removeListener(_markRebuild);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void _markRebuild() {
    setState(() {});
  }
}
