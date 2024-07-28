import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import './image_close_up.dart';

class ImageGrid extends StatelessWidget {
  const ImageGrid({
    super.key,
    required this.images,
    required this.scrollController,
    required this.onRefresh,
  });

  Widget loadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }
    return SizedBox(
      height: 300,
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  Widget frameBuilder(BuildContext context, Widget child, int? frame,
      bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return child;
    }
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      child: child,
    );
  }

  final dynamic images;
  final ScrollController scrollController;
  final void Function() onRefresh;

  void popInAndBecomeFullScreenImage(BuildContext context, dynamic image) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        pageBuilder: (BuildContext context, _, __) {
          // remove the text https://pixabay.com/photos/ from the title and make it not more than 30 characters
          String title = image['pageURL'].substring(30).length > 30
              ? image['pageURL'].substring(30).substring(0, 30) + "..."
              : image['pageURL'].substring(30);

          return ImageCloseUp(
            image: image,
            title: title,
            frameBuilder: frameBuilder,
            loadingBuilder: loadingBuilder,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        child: MasonryGridView.count(
          itemCount: images.length,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: MediaQuery.of(context).size.width > 800 ? 50 : 10,
          ),
          crossAxisCount: MediaQuery.of(context).size.width > 1000
              ? 4
              : MediaQuery.of(context).size.width > 600
                  ? 3
                  : 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          controller: scrollController,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                popInAndBecomeFullScreenImage(context, images[index]);
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(images[index]['webformatURL'],
                    fit: BoxFit.cover,
                    height: images[index]['webformatHeight'] * 0.5,
                    frameBuilder: frameBuilder,
                    loadingBuilder: loadingBuilder),
              ),
            );
          },
        ),
      ),
    );
  }
}
