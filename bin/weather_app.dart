import 'dart:io';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import './weather_model.dart';
import './fetch.dart';

Future<dynamic> getCountryWeather() async {
  print('Choose the country: ');
  List cities = await fetchData<CountryInfo>(
      'https://world-weather.ru/pogoda/', '.countres', 'li');

  int i = 0;
  for (var cityList in cities) {
    i++;
    print('$i: ${cityList.name}');
  }

  print("Enter country index");

  int cityIndex = int.parse(stdin.readLineSync()!);
  print("${cities[cityIndex - 1].name}ning shaharlari: ");

  return cities[cityIndex - 1];
}

Future<List> getCityWeather() async {
  var country = await getCountryWeather();
  print('Choose the City: ');

  List cities = await fetchData<CityInfo>(country.url, '.cities', 'li');

  int i = 0;
  for (var cityList in cities) {
    i++;
    print('$i: ${cityList.name} - ${cityList.temperature}');
  }

  return cities;
}

Future weatherTable() async {
  var city = await getCityWeather();

  int cityIndex = int.parse(stdin.readLineSync()!);

  print("Enter city index");

  print("${city[cityIndex - 1].name}ning ma'lumotlari: ");

  print("-----------------------------------------------");

  // List table = await fetchData<WeatherInfo>(
  //     city[cityIndex - 1].url, 'weather-today', 'tr');
  var baseUrl = city[cityIndex - 1].url.startsWith('//')
      ? "https:${city[cityIndex - 1].url}"
      : city[cityIndex - 1].url;
  dynamic res = await http.get(Uri.parse(baseUrl));

  if (res.statusCode == 200) {
    final document = parse(res.body);
    final titleBar = document.querySelectorAll('.weather-today tr');

    final day = titleBar[0].querySelector('#weather-day')?.text;
    final temperature = titleBar[0].querySelector('#weather-temperature')?.text;
    final feeling = titleBar[0].querySelector('#weather-feeling')?.text;
    final probability = titleBar[0].querySelector('#weather-probability')?.text;
    final pressure = titleBar[0].querySelector('#weather-pressure')?.text;
    final wind = titleBar[0].querySelector('#weather-wind')?.text;
    final humidity = titleBar[0].querySelector('#weather-humidity')?.text;

    print(
        "| $day | $temperature | $feeling | $probability | $pressure | $wind | $humidity | ");

    final body = document.querySelectorAll('.weather-short');

    for (dynamic item in body) {
      print(
          "${item.querySelector('.dates span')?.text}, ${item.querySelector('.dates')?.text}");

      final rows = item.querySelectorAll('table tr');
      print(
          "${rows[0].nodes[0]?.text} | ${rows[0].nodes[1].nodes[1]?.text} | ${rows[0].nodes[2]?.text} | ${rows[0].nodes[3]?.text} | ${rows[0].nodes[4]?.text} | ${rows[0].nodes[5].nodes[2]?.text} | ${rows[0].nodes[6]?.text}");
      print(
          "${rows[1].nodes[0]?.text} | ${rows[1].nodes[1].nodes[1]?.text} | ${rows[1].nodes[2]?.text} | ${rows[1].nodes[3]?.text} | ${rows[1].nodes[4]?.text} | ${rows[1].nodes[5].nodes[2]?.text} | ${rows[1].nodes[6]?.text}");
      print(
          "${rows[2].nodes[0]?.text} | ${rows[2].nodes[1].nodes[1]?.text} | ${rows[2].nodes[2]?.text} | ${rows[2].nodes[3]?.text} | ${rows[2].nodes[4]?.text} | ${rows[2].nodes[5].nodes[2]?.text} | ${rows[2].nodes[6]?.text}");
      print(
          "${rows[3].nodes[0]?.text} | ${rows[3].nodes[1].nodes[1]?.text} | ${rows[3].nodes[2]?.text} | ${rows[3].nodes[3]?.text} | ${rows[3].nodes[4]?.text} | ${rows[3].nodes[5].nodes[2]?.text} | ${rows[3].nodes[6]?.text}");
    }
  }
}

void main(List<String> arguments) {
  weatherTable();
}
