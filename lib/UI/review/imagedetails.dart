import 'package:flutter/material.dart';


// la base de ce code m'a été fournis par on camarad: Julian marques
// Il à été modifié pour qu'il fonctionne avec notre application
class ImageDetail extends StatelessWidget {
  final Image image;

  const ImageDetail({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children:  [
        GestureDetector(
          onTap: () {// pour afficher en plus grands
          showDialog(
            context: context,
            builder: (_) =>
              Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image(image: image.image),
                  ),
                ),
              ),
            );
          },
          child: SizedBox(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: image,
            ),
          ),
        ),
      ]
    );
  }
}