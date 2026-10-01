import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import '../models/prayer_settings.dart';

class PrayerData {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String sehriEnd;
  final String iftar;
  final String currentPrayerName;
  final String nextPrayerName;
  final String nextPrayerTime;
  final String remainingTimeStr;

  PrayerData({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sehriEnd,
    required this.iftar,
    required this.currentPrayerName,
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.remainingTimeStr,
  });
}

class PrayerService {
  static PrayerData calculate(PrayerSettings settings, DateTime date) {
    final coordinates = Coordinates(settings.latitude, settings.longitude);

    CalculationParameters params;
    switch (settings.method) {
      case CalculationMethodType.karachi:
        params = CalculationMethod.karachi.getParameters();
        break;
      case CalculationMethodType.makkah:
        params = CalculationMethod.umm_al_qura.getParameters();
        break;
      case CalculationMethodType.egypt:
        params = CalculationMethod.egyptian.getParameters();
        break;
      case CalculationMethodType.isna:
        params = CalculationMethod.north_america.getParameters();
        break;
      case CalculationMethodType.mwl:
        params = CalculationMethod.muslim_world_league.getParameters();
        break;
      case CalculationMethodType.tehran:
        params = CalculationMethod.tehran.getParameters();
        break;
    }

    params.madhab = settings.madhab == MadhabType.hanafi ? Madhab.hanafi : Madhab.shafi;

    final prayerTimes = PrayerTimes(coordinates, DateComponents.from(date), params);
    final timeFormatter = DateFormat('hh:mm a');

    final sehriTime = prayerTimes.fajr.subtract(Duration(minutes: settings.sehriBufferMinutes));
    final iftarTime = prayerTimes.maghrib;

    final nextPrayer = prayerTimes.nextPrayer();
    final currentPrayer = prayerTimes.currentPrayer();

    String nextName = _prayerToString(nextPrayer);
    String currentName = _prayerToString(currentPrayer);
    DateTime? nextTime = prayerTimes.timeForPrayer(nextPrayer);

    String remainingStr = '';
    String nextTimeStr = '--:--';

    if (nextTime != null) {
      nextTimeStr = timeFormatter.format(nextTime);
      final diff = nextTime.difference(DateTime.now());
      if (!diff.isNegative) {
        remainingStr = '$diff.inHours گھنٹے $diff.inMinutes.remainder(60) منٹ باقی';
      }
    }

    return PrayerData(
      fajr: timeFormatter.format(prayerTimes.fajr),
      sunrise: timeFormatter.format(prayerTimes.sunrise),
      dhuhr: timeFormatter.format(prayerTimes.dhuhr),
      asr: timeFormatter.format(prayerTimes.asr),
      maghrib: timeFormatter.format(prayerTimes.maghrib),
      isha: timeFormatter.format(prayerTimes.isha),
      sehriEnd: timeFormatter.format(sehriTime),
      iftar: timeFormatter.format(iftarTime),
      currentPrayerName: currentName,
      nextPrayerName: nextName,
      nextPrayerTime: nextTimeStr,
      remainingTimeStr: remainingStr,
    );
  }

  static String _prayerToString(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return 'فجر';
      case Prayer.sunrise: return 'طلوعِ آفتاب';
      case Prayer.dhuhr: return 'ظہر';
      case Prayer.asr: return 'عصر';
      case Prayer.maghrib: return 'مغرب';
      case Prayer.isha: return 'عشاء';
      default: return 'تہجد / انتظار';
    }
  }
}
