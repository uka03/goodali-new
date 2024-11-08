import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final String? size;

  CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.size = "medium",
  });

  // Create a custom cache manager with a lower cache limit and shorter stale period
  final CacheManager _customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 3), // Reduce the cache duration
      maxNrOfCacheObjects: 500, // Limit the cache size
    ),
  );

  // Function to generate a resized URL (if the server supports dynamic resizing)
  String _getResizedImageUrl() {
    String modifiedUrl = imageUrl.replaceFirst('/uploads/', '/uploads/$size/');
    return modifiedUrl;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: _getResizedImageUrl(),
        cacheManager: _customCacheManager,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => SizedBox(
          width: width,
          height: height,
          child: ColoredBox(color: Colors.grey[300]!),
        ),
        errorWidget: (context, url, error) {
          return Image.asset(
            "assets/images/image_placeholder.png",
            fit: fit,
            width: width,
            height: height,
          );
        },
      ),
    );
  }
}
