import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Item number $index as title'),
              subtitle: const Text('Subtitle here'),
              trailing: const Icon(Icons.ac_unit),
            ),
          );
        },
      ),
    );
  }
}
