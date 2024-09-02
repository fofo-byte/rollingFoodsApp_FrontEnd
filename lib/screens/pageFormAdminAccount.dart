import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _companyaddress = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text(
          'Rolling Foods',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontFamily: 'Lonely',
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
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: const Column(children: [
                SizedBox(
                  height: 60,
                ),
                ListTile(
                  title: Text('Creation de compte',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  subtitle: Text('Veuillez remplir les champs ci-dessous',
                      style: TextStyle(fontSize: 20)),
                ),
              ]),
            ),
            const SizedBox(
              height: 20,
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
                    controller: _companyaddress,
                    decoration: const InputDecoration(
                      labelText: 'Adresse de l\'entreprise',
                      icon: Icon(Icons.location_on),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Veuillez renseigner l\'adresse de votre entreprise';
                      }
                      return null;
                    },
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
