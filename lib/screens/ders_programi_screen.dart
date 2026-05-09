import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DersProgramiScreen extends StatelessWidget {
  const DersProgramiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteChalc,
      appBar: AppBar(
        title: const Text('Ders Programı'),
        backgroundColor: AppColors.deepForest,
        foregroundColor: AppColors.whiteChalc,
      ),
      body: const Center(child: Text('Ders Programı buraya gelecek')),
    );
  }
}