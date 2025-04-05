import 'package:flutter/material.dart';
import 'package:saemobile/UI/research/decouverte.dart';
import 'package:saemobile/api/restaurantAPI.dart';

import 'InjectedDecouverte.dart';
class TestableDecouverte extends StatelessWidget {
  final RestaurantAPI testApi;

  const TestableDecouverte({required this.testApi, super.key});

  @override
  Widget build(BuildContext context) {
    return InjectedDecouverte(api: testApi);
  }
}
