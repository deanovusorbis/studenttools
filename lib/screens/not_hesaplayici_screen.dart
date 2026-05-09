import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../data/dersler_listesi.dart';

class DersNotu {
  String dersAdi;
  double sinav1;
  double sinav2;
  double sozlu1;
  double sozlu2;

  DersNotu({
    required this.dersAdi,
    required this.sinav1,
    required this.sinav2,
    required this.sozlu1,
    required this.sozlu2,
  });

  double get ortalama => (sinav1 + sinav2 + sozlu1 + sozlu2) / 4;

  String get karneNotu {
    if (ortalama >= 85) return '✨ Pekiyi';
    if (ortalama >= 70) return '👍 İyi';
    if (ortalama >= 55) return '👌 Orta';
    if (ortalama >= 45) return '⚠️ Geçer';
    return '❌ Başarısız';
  }
}

class NotHesaplayiciScreen extends StatefulWidget {
  const NotHesaplayiciScreen({super.key});

  @override
  State<NotHesaplayiciScreen> createState() => _NotHesaplayiciScreenState();
}

class _NotHesaplayiciScreenState extends State<NotHesaplayiciScreen> {
  final List<DersNotu> _dersler = [];

  void _dersSecimEkrani() {
    final manuelController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteChalc,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ders Seç',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepForest,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemCount: DerslerListesi.dersler.length,
                      itemBuilder: (context, index) {
                        final ders = DerslerListesi.dersler[index];
                        final zatenEklendi =
                            _dersler.any((d) => d.dersAdi == ders);
                        return ListTile(
                          leading: const Icon(
                            Icons.book,
                            color: AppColors.scud,
                          ),
                          title: Text(
                            ders,
                            style: TextStyle(
                              color: zatenEklendi
                                  ? AppColors.tasselTaupe
                                  : AppColors.deepForest,
                            ),
                          ),
                          trailing: zatenEklendi
                              ? const Text(
                                  'Eklendi',
                                  style: TextStyle(
                                    color: AppColors.tasselTaupe,
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                          onTap: zatenEklendi
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  _notGirEkrani(ders);
                                },
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Listede Yok mu? Ekle:',
                    style: TextStyle(
                      color: AppColors.tasselTaupe,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: manuelController,
                          decoration: InputDecoration(
                            hintText: 'Ders adı yaz...',
                            filled: true,
                            fillColor: AppColors.clearAqua.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepForest,
                          foregroundColor: AppColors.whiteChalc,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final yeniDers = manuelController.text.trim();
                          if (yeniDers.isNotEmpty &&
                              !DerslerListesi.dersler.contains(yeniDers)) {
                            setModalState(() {
                              DerslerListesi.dersler.add(yeniDers);
                            });
                            manuelController.clear();
                          }
                        },
                        child: const Text('Ekle'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _notGirEkrani(String dersAdi) {
    final sinav1Controller = TextEditingController();
    final sinav2Controller = TextEditingController();
    final sozlu1Controller = TextEditingController();
    final sozlu2Controller = TextEditingController();

    String? hata;

    String? notDogrula() {
      final notlar = [
        double.tryParse(sinav1Controller.text),
        double.tryParse(sinav2Controller.text),
        double.tryParse(sozlu1Controller.text),
        double.tryParse(sozlu2Controller.text),
      ];
      if (notlar.any((n) => n == null)) {
        return 'Lütfen tüm alanları doldur!';
      }
      if (notlar.any((n) => n! > 100 || n < 0)) {
        return 'Notlar 0 ile 100 arasında olmalı!';
      }
      return null;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          void kaydet() {
            final hataMsg = notDogrula();
            if (hataMsg != null) {
              setDialogState(() => hata = hataMsg);
              return;
            }
            setState(() {
              _dersler.add(DersNotu(
                dersAdi: dersAdi,
                sinav1: double.parse(sinav1Controller.text),
                sinav2: double.parse(sinav2Controller.text),
                sozlu1: double.parse(sozlu1Controller.text),
                sozlu2: double.parse(sozlu2Controller.text),
              ));
            });
            Navigator.pop(context);
          }

          return AlertDialog(
            backgroundColor: AppColors.whiteChalc,
            title: Text(
              dersAdi,
              style: const TextStyle(
                color: AppColors.deepForest,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(sinav1Controller, '1. Yazılı', Icons.edit,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus()),
                  const SizedBox(height: 10),
                  _buildTextField(sinav2Controller, '2. Yazılı', Icons.edit,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus()),
                  const SizedBox(height: 10),
                  _buildTextField(
                      sozlu1Controller, '1. Sözlü', Icons.record_voice_over,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus()),
                  const SizedBox(height: 10),
                  _buildTextField(
                      sozlu2Controller, '2. Sözlü', Icons.record_voice_over,
                      onSubmitted: (_) => kaydet()),
                  if (hata != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.alteredPink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber,
                              color: AppColors.deepForest, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              hata!,
                              style: const TextStyle(
                                color: AppColors.deepForest,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'İptal',
                  style: TextStyle(color: AppColors.tasselTaupe),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepForest,
                  foregroundColor: AppColors.whiteChalc,
                ),
                onPressed: kaydet,
                child: const Text('Kaydet'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.tasselTaupe),
        prefixIcon: Icon(icon, color: AppColors.scud),
        filled: true,
        fillColor: AppColors.clearAqua.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  double get _genelOrtalama {
    if (_dersler.isEmpty) return 0;
    return _dersler.map((d) => d.ortalama).reduce((a, b) => a + b) /
        _dersler.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteChalc,
      appBar: AppBar(
        title: const Text(
          'Not Hesaplayıcı',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.deepForest,
        foregroundColor: AppColors.whiteChalc,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.scud,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'Genel Ortalama',
                  style: TextStyle(
                    color: AppColors.deepForest,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _dersler.isEmpty
                      ? '--'
                      : _genelOrtalama.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.deepForest,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _dersler.isEmpty
                ? const Center(
                    child: Text(
                      'Henüz ders eklenmedi.\nAşağıdaki + butonuna bas!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.tasselTaupe,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _dersler.length,
                    itemBuilder: (context, index) {
                      final ders = _dersler[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? AppColors.clearAqua
                              : AppColors.alteredPink,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ders.dersAdi,
                                  style: const TextStyle(
                                    color: AppColors.deepForest,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '📝 ${ders.sinav1} | ${ders.sinav2}   🗣️ ${ders.sozlu1} | ${ders.sozlu2}',
                                  style: const TextStyle(
                                    color: AppColors.deepForest,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  ders.ortalama.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: AppColors.deepForest,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ders.karneNotu,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _dersSecimEkrani,
        backgroundColor: AppColors.deepForest,
        foregroundColor: AppColors.whiteChalc,
        child: const Icon(Icons.add),
      ),
    );
  }
}