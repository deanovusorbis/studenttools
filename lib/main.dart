import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'screens/ders_programi_screen.dart';
import 'screens/sinav_tarihleri_screen.dart';
import 'screens/not_hesaplayici_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eğitim Platformu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.whiteChalc,
        primaryColor: AppColors.deepForest,
      ),
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DersProgramiScreen(),
    const SinavTarihleriScreen(),
    const NotHesaplayiciScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: AppColors.deepForest,
        selectedItemColor: AppColors.clearAqua,
        unselectedItemColor: AppColors.tasselTaupe,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Ders Programı',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Sınavlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Not Hesapla',
          ),
        ],
      ),
    );
  }
}