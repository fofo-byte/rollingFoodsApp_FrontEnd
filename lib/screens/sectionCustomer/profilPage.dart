import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilpage extends StatefulWidget {
  const Profilpage({super.key});

  @override
  State<Profilpage> createState() => _ProfilpageState();
}

class _ProfilpageState extends State<Profilpage> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Si un utilisateur est connecté via Google, déconnexion de Google Sign-In
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
      print('GoogleSignIn successfully signed out.');
    }

    // Déconnexion de Firebase Auth
    await FirebaseAuth.instance.signOut();
    print('FirebaseAuth successfully signed out.');

    // Effacer toutes les données de session de l'application
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('Local data cleared.');

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Loginpage()));
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null) {
      setState(() {
        username = savedUsername;
      });
    } else {
      setState(() {
        username = FirebaseAuth.instance.currentUser!.displayName!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          const Text(
            'Profil',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage:
                NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
          ),
          const SizedBox(height: 20),
          Text(
            'Bonjour, $username',
            style: const TextStyle(fontSize: 20),
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
            thickness: 0.5,
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              alignment:
                  Alignment.centerLeft, // Aligne le contenu du bouton à gauche
            ),
            child: const Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Aligne les enfants à gauche
              children: [
                Icon(Icons.notifications),
                SizedBox(width: 20), // Espacement entre l'icône et le texte
                Text('Notifications', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              alignment:
                  Alignment.centerLeft, // Aligne le contenu du bouton à gauche
            ),
            child: const Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Aligne les enfants à gauche
              children: [
                Icon(Icons.delete),
                SizedBox(width: 20), // Espacement entre l'icône et le texte
                Text('Supprimer profil', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              alignment:
                  Alignment.centerLeft, // Aligne le contenu du bouton à gauche
            ),
            child: const Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Aligne les enfants à gauche
              children: [
                Icon(Icons.info),
                SizedBox(width: 20), // Espacement entre l'icône et le texte
                Text('A propos', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 250),
          ElevatedButton(
            onPressed: _logout,
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}
