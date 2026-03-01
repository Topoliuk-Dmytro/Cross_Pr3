import 'package:flutter/material.dart';

void main() => runApp(const SolarApp());

class SolarApp extends StatelessWidget {
  const SolarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SolarPage(),
    );
  }
}

class SolarPage extends StatefulWidget {
  const SolarPage({super.key});

  @override
  State<SolarPage> createState() => _SolarPageState();
}

class _SolarPageState extends State<SolarPage> {
  final _pc = TextEditingController(text: '5');     // МВт
  final _price = TextEditingController(text: '7');  // грн/кВт·год
  final _delta1 = TextEditingController(text: '20'); // %
  final _delta2 = TextEditingController(text: '68'); // %

  String _result = '';

  double _p(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.')) ?? double.nan;

  String _f(double v) => v.toStringAsFixed(2);

  void _calculate() {
    final Pc = _p(_pc);
    final B = _p(_price);
    final d1 = _p(_delta1) / 100;
    final d2 = _p(_delta2) / 100;

    if ([Pc, B, d1, d2].any((v) => v.isNaN)) {
      setState(() => _result = 'Помилка введення даних');
      return;
    }

    // До вдосконалення
    final W1 = Pc * 24 * d1; // МВт·год
    final profit1 = W1 * 1000 * B; // грн

    final W2 = Pc * 24 * (1 - d1);
    final fine1 = W2 * 1000 * B;

    final balance1 = profit1 - fine1;

    // Після вдосконалення
    final W3 = Pc * 24 * d2;
    final profit2 = W3 * 1000 * B;

    final W4 = Pc * 24 * (1 - d2);
    final fine2 = W4 * 1000 * B;

    final balance2 = profit2 - fine2;

    final improvement = balance2 - balance1;

    setState(() {
      _result = '''
До вдосконалення:
Прибуток = ${_f(profit1 / 1000)} тис. грн
Штраф = ${_f(fine1 / 1000)} тис. грн
Баланс = ${_f(balance1 / 1000)} тис. грн

Після вдосконалення:
Прибуток = ${_f(profit2 / 1000)} тис. грн
Штраф = ${_f(fine2 / 1000)} тис. грн
Баланс = ${_f(balance2 / 1000)} тис. грн

Додатковий прибуток:
${_f(improvement / 1000)} тис. грн
''';
    });
  }

  Widget _field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Практична №3 — СЕС')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field('Потужність станції Pc (МВт)', _pc),
            _field('Ціна електроенергії (грн/кВт·год)', _price),
            _field('δ₁ до вдосконалення (%)', _delta1),
            _field('δ₂ після вдосконалення (%)', _delta2),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Розрахувати'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _result,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}