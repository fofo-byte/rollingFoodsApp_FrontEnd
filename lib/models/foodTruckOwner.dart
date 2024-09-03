import 'package:rolling_foods_app_front_end/models/address.dart';

class Foodtruckowner {
  String firstname;
  String lastname;
  String phonenumber;
  String tva;
  String banknumber;
  String companyname;
  Address address;

  Foodtruckowner({
    required this.firstname,
    required this.lastname,
    required this.phonenumber,
    required this.tva,
    required this.banknumber,
    required this.companyname,
    required this.address,
  });

  factory Foodtruckowner.fromJson(Map<String, dynamic> json) {
    return Foodtruckowner(
      firstname: json['firstname'],
      lastname: json['lastname'],
      phonenumber: json['phoneNumber'],
      tva: json['tva'],
      banknumber: json['bankNumber'],
      companyname: json['companyName'],
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'phoneNumber': phonenumber,
        'tva': tva,
        'bankNumber': banknumber,
        'companyName': companyname,
        'address': address.toJson(),
      };
}
