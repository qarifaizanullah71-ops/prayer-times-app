enum MadhabType { hanafi, shafi }
enum CalculationMethodType { karachi, makkah, egypt, isna, mwl, tehran }

class PrayerSettings {
  final double latitude;
  final double longitude;
  final String cityName;
  final MadhabType madhab;
  final CalculationMethodType method;
  final int sehriBufferMinutes;

  PrayerSettings({
    this.latitude = 33.6844,
    this.longitude = 73.0479,
    this.cityName = 'اسلام آباد، پاکستان',
    this.madhab = MadhabType.hanafi,
    this.method = CalculationMethodType.karachi,
    this.sehriBufferMinutes = 10,
  });

  PrayerSettings copyWith({
    double? latitude,
    double? longitude,
    String? cityName,
    MadhabType? madhab,
    CalculationMethodType? method,
    int? sehriBufferMinutes,
  }) {
    return PrayerSettings(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      madhab: madhab ?? this.madhab,
      method: method ?? this.method,
      sehriBufferMinutes: sehriBufferMinutes ?? this.sehriBufferMinutes,
    );
  }
}
