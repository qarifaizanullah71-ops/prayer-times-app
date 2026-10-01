import 'package:flutter/material.dart';
import '../models/prayer_settings.dart';
import '../services/prayer_service.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PrayerSettings _settings = PrayerSettings();
  late PrayerData _data;

  @override
  void initState() {
    super.initState();
    _refreshTimes();
  }

  void _refreshTimes() {
    setState(() {
      _data = PrayerService.calculate(_settings, DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopHeader(),
              const SizedBox(height: 16),
              _buildHeroNextPrayer(),
              const SizedBox(height: 16),
              _buildSehriIftarCards(),
              const SizedBox(height: 20),
              _buildSectionHeader(),
              const SizedBox(height: 12),
              _buildPrayerTile('فجر', _data.fajr, Icons.nightlight_round),
              _buildPrayerTile('طلوعِ آفتاب', _data.sunrise, Icons.wb_sunny_outlined, isMuted: true),
              _buildPrayerTile('ظہر', _data.dhuhr, Icons.wb_sunny),
              _buildPrayerTile('عصر', _data.asr, Icons.wb_twilight),
              _buildPrayerTile('مغرب', _data.maghrib, Icons.nights_stay_outlined),
              _buildPrayerTile('عشاء', _data.isha, Icons.bedtime),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFFE2B96F), size: 22),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _settings.cityName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text('اوقات برائے آج', style: TextStyle(fontSize: 12, color: Colors.white60)),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Color(0xFFE2B96F)),
          onPressed: () async {
            final updated = await Navigator.push<PrayerSettings>(
              context,
              MaterialPageRoute(builder: (c) => SettingsScreen(settings: _settings)),
            );
            if (updated != null) {
              _settings = updated;
              _refreshTimes();
            }
          },
        ),
      ],
    );
  }

  Widget _buildHeroNextPrayer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F3E36), Color(0xFF1B5E50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2B96F).withOpacity(0.4), width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('اگلی نماز', style: TextStyle(color: Color(0xFFE2B96F), fontSize: 13)),
              ),
              const Icon(Icons.mosque, color: Colors.white70, size: 24),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _data.nextPrayerName,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            _data.nextPrayerTime,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE2B96F)),
          ),
          const SizedBox(height: 8),
          Text(
            _data.remainingTimeStr,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSehriIftarCards() {
    return Row(
      children: [
        Expanded(child: _snippet('سحری (امساک)', _data.sehriEnd, Icons.nightlight_outlined, const Color(0xFF64B5F6))),
        const SizedBox(width: 12),
        Expanded(child: _snippet('افطار (مغرب)', _data.iftar, Icons.wb_sunny_outlined, const Color(0xFFFFB74D))),
      ],
    );
  }

  Widget _snippet(String title, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF112136),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            radius: 18,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.white60)),
              Text(time, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    final madhabName = _settings.madhab == MadhabType.hanafi ? 'حنفی' : 'شافعی / دیگر';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('نمازوں کے اوقات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Text('مسلک: ', style: const TextStyle(fontSize: 13, color: Color(0xFFE2B96F))),
      ],
    );
  }

  Widget _buildPrayerTile(String name, String time, IconData icon, {bool isMuted = false}) {
    final bool isNext = (_data.nextPrayerName == name);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isNext ? const Color(0xFF133E35) : const Color(0xFF101F33),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNext ? const Color(0xFFE2B96F) : Colors.white.withOpacity(0.05),
          width: isNext ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: isNext ? const Color(0xFFE2B96F) : (isMuted ? Colors.white30 : Colors.white70)),
          const SizedBox(width: 14),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              color: isNext ? const Color(0xFFE2B96F) : (isMuted ? Colors.white60 : Colors.white),
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isNext ? Colors.white : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
