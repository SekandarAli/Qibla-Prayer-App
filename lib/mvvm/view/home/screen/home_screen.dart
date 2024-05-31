import 'package:flutter/material.dart';
import 'package:namaz_timing_app/mvvm/view_model/utils/color/color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorsTheme.backgroundColor,
      ),
    );
  }
}
