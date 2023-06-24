import 'package:flutter/material.dart';

import '../util/callback.dart';

class ImageList extends StatelessWidget {
  const ImageList(
      {super.key,
      required this.imageProviders,
      required this.tags,
      required this.onPressedAdd,
      required this.onPressedImage,
      required this.canAdd});

  final List<ImageProvider> imageProviders;

  /// Heroウィジェットに使用するタグ
  final List<String> tags;
  final VoidCallback onPressedAdd;
  final IndexCallback onPressedImage;
  final bool canAdd;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0 && canAdd) {
            return ImageListItem(
                onPressed: onPressedAdd,
                child: Expanded(
                  child: OutlinedButton(
                    onPressed: onPressedAdd,
                    style:
                        OutlinedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
                    child: const Icon(Icons.add),
                  ),
                ));
          } else {
            final i = canAdd ? index - 1 : index;
            return ImageListItem(
                onPressed: () => onPressedImage(i),
                child: Hero(
                    tag: tags[i],
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(fit: BoxFit.cover, alignment: FractionalOffset.topCenter, image: imageProviders[i])))));
          }
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: canAdd ? imageProviders.length + 1 : imageProviders.length);
  }
}

class ImageListItem extends StatelessWidget {
  const ImageListItem({super.key, required this.child, this.width, this.height, required this.onPressed});

  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(width: width ?? 120, height: height ?? 120, child: child),
      ),
    );
  }
}
