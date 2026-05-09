import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SinavTarihleriScreen extends StatelessWidget {
  const SinavTarihleriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteChalc,
      appBar: AppBar(
        title: const Text('Sınav Tarihleri'),
        backgroundColor: AppColors.deepForest,
        foregroundColor: AppColors.whiteChalc,
      ),
      body: const Center(child: Text('Sınav Tarihleri buraya gelecek')),
    );
  }
}
