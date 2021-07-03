import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../source.dart';

enum ImageNetworkShape { none, circle }

class WidgetImageNetwork extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final double circular;

  final ShimmerDirection shimmerDirection;
  final Duration shimmerDuration;
  final BoxFit fit;

  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;
  final Color shimmerBackColor;

  final Widget errorWidget;
  final BoxDecoration boxDecoration;

  const WidgetImageNetwork({
    @required this.url,
    this.fit = BoxFit.fill,
    this.width = 300,
    this.height = 300,
    this.circular = 0,
    this.shimmerDirection = ShimmerDirection.ltr,
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.shimmerBackColor,
    this.errorWidget,
    this.boxDecoration,
  });

  ///Base color of the Shimmer effect
  static const Default_Shimmer_BaseColor =
      const Color.fromRGBO(64, 64, 64, 0.5);

  ///Base color of the Highlight effect
  static const Default_Shimmer_Highlight_Color =
      const Color.fromRGBO(166, 166, 166, 1.0);

  ///Base color of the back collor
  static const Default_Shimmer_BackColor =
      const Color.fromRGBO(217, 217, 217, 0.5);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(circular),
      child: url != null
          ? CachedNetworkImage(
              imageUrl: url,
              fit: fit,
              width: width,
              height: height,
              placeholder: (context, url) => boxDecoration != null
                  ? Shimmer.fromColors(
                      baseColor: shimmerBaseColor ?? Default_Shimmer_BaseColor,
                      highlightColor: shimmerHighlightColor ??
                          Default_Shimmer_Highlight_Color,
                      direction: shimmerDirection,
                      period: shimmerDuration,
                      child: Container(
                        width: width,
                        height: height,
                        decoration: boxDecoration,
                      ),
                    )
                  : SizedBox(
                      width: width,
                      height: height,
                      child: Shimmer.fromColors(
                        baseColor:
                            shimmerBaseColor ?? Default_Shimmer_BaseColor,
                        highlightColor: shimmerHighlightColor ??
                            Default_Shimmer_Highlight_Color,
                        direction: shimmerDirection,
                        period: shimmerDuration,
                        child: Container(
                          width: width,
                          height: height,
                          color: shimmerBackColor ?? Default_Shimmer_BackColor,
                        ),
                      ),
                    ),
              errorWidget: (context, url, error) => _buildImageNetworkError(),
            )
          : _buildImageNetworkError(),
    );
  }

  Widget _buildImageNetworkError() {
    return Image.network(
      'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1',
      errorBuilder: (c, _, __) => Container(
        width: width,
        height: height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            Text('Error loading Image')
          ],
        ),
      ),
    );
  }
}
