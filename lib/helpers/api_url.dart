class ApiUrl {
  static const String baseUrl = 'https://api.open-meteo.com/v1';
  static const String geocodingUrl = 'https://geocoding-api.open-meteo.com/v1';

  static String forecast(double latitude, double longitude) {
    return baseUrl +
        '/forecast?latitude=' + latitude.toString() +
        '&longitude=' + longitude.toString() +
        '&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m' +
        '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max' +
        '&timezone=auto&forecast_days=7';
  }

  static String searchLocation(String name) {
    return geocodingUrl +
        '/search?name=' + Uri.encodeComponent(name) +
        '&count=10&language=id&format=json';
  }
}