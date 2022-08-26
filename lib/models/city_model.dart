import 'dart:convert';

const String cityName = 'name';
const String cityArea = 'area';

class CityModel {
  String name;
  List<String> area;

  CityModel({required this.name, required this.area});

  Map<String, dynamic> toMap() {
    return {
      cityName: name,
      cityArea: jsonEncode(area),
    };
  }

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      name: map[cityName],
      area: List.of(map[cityArea]).map((i) => i.toString()).toList(),
    );
  }
//

}
