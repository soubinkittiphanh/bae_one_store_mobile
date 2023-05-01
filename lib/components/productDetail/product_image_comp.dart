import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          width: deviceSize.width * 0.30,
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imagePath.contains("No image")
                ? const Text('No image')
                : Hero(
                    tag: imagePath,
                    child: CachedNetworkImage(
                      imageUrl: imagePath,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.fitHeight,
                      height: deviceSize.height * 0.43,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
