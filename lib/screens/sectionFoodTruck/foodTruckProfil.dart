import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rolling_foods_app_front_end/models/article.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/services/article_service.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';

class Foodtruckprofil extends StatefulWidget {
  final int foodtruckId;

  const Foodtruckprofil({super.key, required this.foodtruckId});

  @override
  State<Foodtruckprofil> createState() => _FoodtruckprofilState();
}

class _FoodtruckprofilState extends State<Foodtruckprofil> {
  late Future<Foodtruck> foodTruck;
  late Future<List<Article>> article;
  late Future<List<Article>> articleSpeciality;
  late Future<List<Article>> articleNew;
  final MapController _mapController = MapController();

  final List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    foodTruck = ApiService().fetchFoodTruckById(widget.foodtruckId);
    article = ArticleService()
        .getItemsByFoodTruckIdAndCategory(widget.foodtruckId, 'PROMOTION');
    articleSpeciality = ArticleService()
        .getItemsByFoodTruckIdAndCategory(widget.foodtruckId, 'SPECIALITY');
    articleNew = ArticleService()
        .getItemsByFoodTruckIdAndCategory(widget.foodtruckId, 'NEW');
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
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              Text(
                'Rolling Foods',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'InriaSans',
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<Foodtruck>(
            future: foodTruck,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data'));
              }
              Foodtruck foodtruck = snapshot.data!;

              markers.add(Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(foodtruck.coordinates!.latitude,
                    foodtruck.coordinates!.longitude),
                child: const Icon(Icons.pin_drop, color: Colors.red),
              ));

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 300,
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          maxZoom: 15,
                          initialCenter: LatLng(foodtruck.coordinates!.latitude,
                              foodtruck.coordinates!.longitude),
                          initialZoom: 14,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'dev.fleaflet.flutter_map.example',
                            // Plenty of other options available!
                          ),
                          MarkerLayer(
                            markers: markers,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10, vertical: 0),
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: foodtruck.urlProlfileImage != null
                            ? NetworkImage(foodtruck.urlProlfileImage!)
                            : const AssetImage('assets/images/foodtruck.jpg')
                                as ImageProvider,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                foodtruck.name,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.favorite_border),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            textAlign: TextAlign.center,
                            foodtruck.description,
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                          //insert lines
                          const Divider(
                            color: Colors.black,
                            height: 20,
                            thickness: 2,
                            indent: 20,
                            endIndent: 20,
                          ),
                          FutureBuilder<List<Article>>(
                            future: article,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('Pas de promotion disponible'));
                              }
                              List<Article> articles = snapshot.data!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Text(
                                      'Promotion',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: articles.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(articles[index].name),
                                          subtitle:
                                              Text(articles[index].description),
                                          trailing: Text(
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              '€${articles[index].price.toString()}'),
                                          leading: CircleAvatar(
                                            backgroundImage: articles[index]
                                                        .urlPicture !=
                                                    null
                                                ? NetworkImage(
                                                    articles[index].urlPicture!)
                                                : const AssetImage(
                                                        'assets/images/foodtruck.jpg')
                                                    as ImageProvider,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          FutureBuilder(
                            future: articleSpeciality,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child:
                                        Text('Pas de spécialité disponible'));
                              }
                              List<Article> articles = snapshot.data!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Text(
                                      'Spécialité',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: articles.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(articles[index].name),
                                          subtitle:
                                              Text(articles[index].description),
                                          trailing: Text(
                                            '€${articles[index].price.toString()}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          leading: CircleAvatar(
                                            backgroundImage: articles[index]
                                                        .urlPicture !=
                                                    null
                                                ? NetworkImage(
                                                    articles[index].urlPicture!)
                                                : const AssetImage(
                                                        'assets/images/foodtruck.jpg')
                                                    as ImageProvider,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          FutureBuilder(
                            future: articleNew,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('Pas de nouveauté disponible'));
                              }
                              List<Article> articles = snapshot.data!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Text(
                                      'Nouveauté',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: articles.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(articles[index].name),
                                          subtitle:
                                              Text(articles[index].description),
                                          trailing: Text(
                                            '€${articles[index].price.toString()}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          leading: CircleAvatar(
                                            backgroundImage: articles[index]
                                                        .urlPicture !=
                                                    null
                                                ? NetworkImage(
                                                    articles[index].urlPicture!)
                                                : const AssetImage(
                                                        'assets/images/foodtruck.jpg')
                                                    as ImageProvider,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
