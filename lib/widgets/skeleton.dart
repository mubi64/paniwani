// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  Skeleton({Key? key, this.height, this.width, this.radius}) : super(key: key);

  double? height, width, radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xF4000000),
      highlightColor: const Color(0xFF353535).withOpacity(0.04),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(16.0 / 2),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 8.0)),
        ),
      ),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}
