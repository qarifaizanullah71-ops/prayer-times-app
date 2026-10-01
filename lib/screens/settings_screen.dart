import 'package:flutter/material.dart';
import '../models/prayer_settings.dart';

class SettingsScreen extends StatefulWidget {
  final PrayerSettings settings;
  const SettingsScreen({super.key, required this.settings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late MadhabType _madhab;
  late CalculationMethodType _method;
  late int _buffer;

  @override
  void initState() {
    super.initState();
    _madhab = widget.settings.madhab;
    _method = widget.settings.method;
    _buffer = widget.settings.sehriBufferMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مسلکی و فلکیاتی ترتیبات'),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('عصر کی فقہی ترتیب (مسلک)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE2B96F))),
          RadioListTile<MadhabType>(
            title: const Text('حنفی (سایہ دو گنا)'),
            subtitle: const Text('پاکستان، بھارت، ترکی، وسطی ایشیا'),
            value: MadhabType.hanafi,
            groupValue: _madhab,
            onChanged: (v) => setState(() => _madhab = v!),
          ),
          RadioListTile<MadhabType>(
            title: const Text('شافعی / مالکی / حنبلی (سایہ ایک گنا)'),
            subtitle: const Text('سعودی عرب، مصر، ملائیشیا، شام'),
            value: MadhabType.shafi,
            groupValue: _madhab,
            onChanged: (v) => setState(() => _madhab = v!),
          ),
          const Divider(height: 30),
          const Text('حسابی ادارہ / طریقہ کار', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE2B96F))),
          DropdownButtonFormField<CalculationMethodType>(
            value: _method,
            dropdownColor: const Color(0xFF101F33),
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: CalculationMethodType.karachi, child: Text('جامعہ علوم اسلامیہ بنوری ٹاؤن (کراچی)')),
              DropdownMenuItem(value: CalculationMethodType.makkah, child: Text('ام القریٰ (مکہ مکرمہ)')),
              DropdownMenuItem(value: CalculationMethodType.egypt, child: Text('جامعہ ازہر (مصر)')),
              DropdownMenuItem(value: CalculationMethodType.isna, child: Text('ISNA (امریکہ و کینیڈا)')),
              DropdownMenuItem(value: CalculationMethodType.mwl, child: Text('مسلم ورلڈ لیگ (یورپ و دیگر)')),
              DropdownMenuItem(value: CalculationMethodType.tehran, child: Text('مؤسسہ لواء القم (فقہ جعفریہ)')),
            ],
            onChanged: (v) => setState(() => _method = v!),
          ),
          const Divider(height: 30),
          const Text('سحری کا احتیاطی وقت (امساک)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE2B96F))),
          Slider(
            value: _buffer.toDouble(),
            min: 0,
            max: 20,
            divisions: 4,
            label: '$_buffer منٹ پہلے',
            activeColor: const Color(0xFFE2B96F),
            onChanged: (v) => setState(() => _buffer = v.toInt()),
          ),
          Text('فجر سے $_buffer منٹ قبل سحری بند ہوگی۔', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E50),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Navigator.pop(
                context,
                widget.settings.copyWith(
                  madhab: _madhab,
                  method: _method,
                  sehriBufferMinutes: _buffer,
                ),
              );
            },
            child: const Text('محفوظ کریں', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
