import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shows shimmer effect over widget.
class ShimmerWrapper extends StatelessWidget {
  final Widget child;

  const ShimmerWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[300]!,
      child: child,
    );
  }
}