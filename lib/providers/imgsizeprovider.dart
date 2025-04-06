// import 'package:flutter/material.dart';
//
// //cette classe a été généré avec chatgpt pour regler les probleme d'affichage
// // sur différent appareil mobile
// class ImageSizeProvider extends ChangeNotifier {
//   double _size = 50.0;
//
//   double get size => _size;
//
//   void setSize(double newSize) {
//     _size = newSize;
//     notifyListeners();
//   }
// }
//genéré par GPT mais pas utilisé (trop compliqué)
import 'package:flutter/material.dart';

class ImageSizeManager {
  static final ValueNotifier<double> imageSize = ValueNotifier<double>(50.0);
}