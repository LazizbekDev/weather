import "package:http/http.dart" as http;
import "package:html/parser.dart";

import "./weather_model.dart";

Future<List> fetchData<T>(
    String url, String parentElement, String listElement) async {
  try {
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final document = parse(res.body);
      final elements = document.querySelectorAll(parentElement);
      List<T> items = [];

      for (dynamic element in elements) {
        final handle = element.querySelectorAll(listElement);

        for (dynamic list in handle) {
          final a = list.querySelector('a');
          if (a?.innerHtml != null) {
            if (T == CountryInfo) {
              items.add(
                  CountryInfo(name: a?.innerHtml, url: a?.attributes['href'])
                      as T);
            } else if (T == CityInfo) {
              items.add(CityInfo(
                  name: a?.text,
                  url: a?.attributes['href'],
                  temperature: list.querySelector('span')?.text) as T);
            }
          }
        }
      }
      return items;
    } else {
      throw Exception("Error");
    }
  } catch (e) {
    print(e);
    return [];
  }
}
