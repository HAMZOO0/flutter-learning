import 'dart:async';

Future<String> weather_data(String city) async {
  await Future.delayed(Duration(seconds: 3));
  return " Weather: 27°C of $city";
}

void main() async {
  print("Here we calling the api ");
  String data = await weather_data("ISB");
  print("Weather data $data ");
  print("i am after api call consol printer ");
}
