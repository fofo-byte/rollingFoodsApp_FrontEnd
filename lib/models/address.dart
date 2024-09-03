class Address {
  String street;
  String streetNumber;
  String postalCode;
  String city;
  String province;
  String country;

  Address({
    required this.street,
    required this.streetNumber,
    required this.postalCode,
    required this.city,
    required this.province,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      streetNumber: json['streetNumber'],
      postalCode: json['postalCode'],
      city: json['city'],
      province: json['province'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() => {
        'street': street,
        'streetNumber': streetNumber,
        'postalCode': postalCode,
        'city': city,
        'province': province,
        'country': country,
      };
}
