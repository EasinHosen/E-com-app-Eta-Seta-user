import 'package:cloud_firestore/cloud_firestore.dart';

const String addressStAddress = 'streetAddress';
const String addressArea = 'area';
const String addressCity = 'city';
const String addressZipCode = 'zipCode';

class AddressModel {

  String streetAddress, area, city;
  int zipCode;


  AddressModel({required this.streetAddress, required this.area, required this.city, required this.zipCode});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      addressStAddress: streetAddress,
      addressArea: area,
      addressCity: city,
      addressZipCode: zipCode,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
        streetAddress: map[addressStAddress],
        area: map[addressArea],
        city: map[addressCity],
        zipCode: map[addressZipCode]);
  }

  @override
  String toString() {
    return 'AddressModel{streetAddress: $streetAddress, area: $area, city: $city, zipCode: $zipCode}';
  }
}
