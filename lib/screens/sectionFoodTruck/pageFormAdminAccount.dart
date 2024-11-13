import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/loginPage.dart';
import 'package:rolling_foods_app_front_end/services/user_service_API.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pageformadminaccount extends StatefulWidget {
  const Pageformadminaccount({super.key});

  @override
  State<Pageformadminaccount> createState() => _PageformadminaccountState();
}

class _PageformadminaccountState extends State<Pageformadminaccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _banknumber = TextEditingController();
  final TextEditingController _companyname = TextEditingController();
  final TextEditingController _tva = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _streetnumber = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _postalcode = TextEditingController();
  final TextEditingController _province = TextEditingController();
  final TextEditingController _country = TextEditingController();

  int? idUserCredential;

  @override
  void initState() {
    super.initState();
    _loadUserCredential();
  }

  Future<void> _loadUserCredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUserCredential = prefs.getInt('id') ?? 0;
    });
  }

  Future<void> _registerAdminAccount() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      String firstname = _firstname.text;
      String lastname = _lastname.text;
      String phonenumber = _phonenumber.text;
      String banknumber = _banknumber.text;
      String companyname = _companyname.text;
      String tva = _tva.text;
      String street = _street.text;
      String streetnumber = _streetnumber.text;
      String city = _city.text;
      String postalcode = _postalcode.text;
      String province = _province.text;
      String country = _country.text;

      try {
        UserServiceApi().registerFoodTruckAccount(
            idUserCredential!,
            firstname,
            lastname,
            phonenumber,
            tva,
            banknumber,
            companyname,
            street,
            streetnumber,
            city,
            postalcode,
            province,
            country);
        // Inform the user of successful registration
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Admin account registered successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        print('Failed to register admin account: $e');
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _firstname.dispose();
    _lastname.dispose();
    _phonenumber.dispose();
    _banknumber.dispose();
    _companyname.dispose();
    _tva.dispose();
    _street.dispose();
    _streetnumber.dispose();
    _city.dispose();
    _postalcode.dispose();
    _province.dispose();
    _country.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Loginpage(),
              ),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          'Hello Foods',
          style: TextStyle(
            color: Colors.black,
            fontSize: 50,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: const Column(children: [
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text('Creation de compte',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  subtitle: Text('Veuillez remplir les champs ci-dessous',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20)),
                ),
              ]),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstname,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      icon: Icon(Icons.person),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner votre prénom';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastname,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      icon: Icon(Icons.person),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner votre nom';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phonenumber,
                    decoration: const InputDecoration(
                      labelText: 'Numéro de téléphone',
                      icon: Icon(Icons.phone),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner votre numéro de téléphone';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _banknumber,
                    decoration: const InputDecoration(
                      labelText: 'Numéro de compte bancaire',
                      icon: Icon(Icons.account_balance),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner votre numéro de compte bancaire';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _companyname,
                    decoration: const InputDecoration(
                      labelText: 'Nom de l\'entreprise',
                      icon: Icon(Icons.business),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner le nom de votre entreprise';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _tva,
                    decoration: const InputDecoration(
                      labelText: 'Numéro de TVA',
                      icon: Icon(Icons.business),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner le numéro de TVA';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _street,
                    decoration: const InputDecoration(
                      labelText: 'Adresse de l\'entreprise (Rue)',
                      icon: Icon(Icons.location_on),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner l\'adresse de votre entreprise';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _streetnumber,
                    decoration: const InputDecoration(
                      labelText: 'Numéro de rue',
                      icon: Icon(Icons.location_on),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner le numéro de rue';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _city,
                    decoration: const InputDecoration(
                      labelText: 'Ville',
                      icon: Icon(Icons.location_city),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner la ville';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _postalcode,
                    decoration: const InputDecoration(
                      labelText: 'Code postal',
                      icon: Icon(Icons.location_city),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner le code postal';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _province,
                    decoration: const InputDecoration(
                      labelText: 'Province',
                      icon: Icon(Icons.location_city),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner la province';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _country,
                    decoration: const InputDecoration(
                      labelText: 'Pays',
                      icon: Icon(Icons.location_city),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner le pays';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _registerAdminAccount();
                    },
                    child: const Text('Créer un compte'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
