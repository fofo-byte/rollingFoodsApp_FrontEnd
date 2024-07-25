import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service.dart';

class HomeCustomer extends StatefulWidget {
  const HomeCustomer({super.key});

  @override
  State<HomeCustomer> createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {
  late Future<List<Foodtruck>> foodTrucks;

  @override
  void initState() {
    super.initState();
    foodTrucks = ApiService().fetchFoodTrucks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.jpeg',
              scale: 14,
              fit: BoxFit.contain,
              height: 45,
            ),
            const Text(
              'Rolling Foods',
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Lonely',
                  letterSpacing: 2.0),
            ),
          ],
        ),
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Section for search bar
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 150,
              child: const Center(
                child: Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for food trucks',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //Section for food trucks
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Food Trucks à proximité',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            FutureBuilder<List<Foodtruck>>(
              future: foodTrucks,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Foodtruck>? data = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Theme.of(context).colorScheme.primary,
                        child: ListTile(
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          title: Text(data[index].name),
                          subtitle: Text(data[index].description),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
