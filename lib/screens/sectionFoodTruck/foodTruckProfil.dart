// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:rolling_foods_app_front_end/models/article.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/services/article_service.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isFavorite = false;

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
    checkFavoriteFoodTruck();
  }

  //Submit a rating
  Future<void> submitRating(int foodTruckId, int rating) async {
    try {
      print('Submitting rating $rating for food truck $foodTruckId');
      final response = await http.put(
        Uri.parse(
            'http://10.0.2.2:8686/api/rateFoodTruck?foodTruckId=$foodTruckId&rating=$rating'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print('Successfully submitted rating');
      } else {
        print('Failed to submit rating, status code: ${response.statusCode}');
        throw Exception('Failed to submit rating');
      }
    } catch (e) {
      print('Failed to submit rating: $e');
      throw Exception('Failed to submit rating');
    }
  }

  Future<void> openGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<void> favoriteFoodTruck() async {
    try {
      ApiService().addFavoriteFoodTruck(widget.foodtruckId);
    } catch (e) {
      print('Failed to add favorite food truck: $e');
      throw Exception('Failed to add favorite food truck');
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<bool> checkFavoriteFoodTruck() async {
    isFavorite = await ApiService().isFavoriteFoodTruck(widget.foodtruckId);
    setState(() {
      isFavorite = isFavorite;
    });
    return isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //Adjustement for responsive design
    double mapHeight = screenHeight * 0.3;
    double avatarSize = screenWidth * 0.10;

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
                'Hello Foods',
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
                child: Column(
                  children: [
                    IconButton(
                        tooltip: 'Itinéraire',
                        onPressed: () {
                          openGoogleMaps(foodtruck.coordinates!.latitude,
                              foodtruck.coordinates!.longitude);
                        },
                        icon: const Icon(Icons.location_on,
                            color: Colors.red, size: 40)),
                    const Text("Let's Go!",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ));

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: mapHeight,
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              maxZoom: 15,
                              initialCenter: LatLng(
                                  foodtruck.coordinates!.latitude,
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
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: Icon(Icons.favorite,
                                      size: 40,
                                      color: isFavorite
                                          ? Colors.red
                                          : Colors.grey),
                                  tooltip: 'Ajouter aux favoris',
                                  onPressed: () {
                                    favoriteFoodTruck();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10, vertical: 0),
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: avatarSize,
                            backgroundImage: foodtruck.urlProlfileImage != null
                                ? NetworkImage(foodtruck.urlProlfileImage!)
                                : const AssetImage(
                                        'assets/images/foodtruck.jpg')
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                foodtruck.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.07,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                foodtruck.description,
                                style: TextStyle(fontSize: screenWidth * 0.04),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              RatingBarIndicator(
                                rating: foodtruck.rating != null
                                    ? foodtruck.rating!.toDouble()
                                    : 0.0,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Notez le food truck'),
                                        content: RatingBar.builder(
                                          initialRating: 0,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            submitRating(
                                                foodtruck.id, rating.toInt());
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(FontAwesomeIcons.thumbsUp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.02,
                                            vertical: screenHeight * 0.02),
                                        child: Card(
                                          child: ListTile(
                                            title: Text(articles[index].name),
                                            subtitle: Text(
                                                articles[index].description),
                                            trailing: Text(
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                '€${articles[index].price.toString()}'),
                                            leading: CircleAvatar(
                                              backgroundImage: articles[index]
                                                          .urlPicture !=
                                                      null
                                                  ? NetworkImage(articles[index]
                                                      .urlPicture!)
                                                  : const AssetImage(
                                                          'assets/images/foodtruck.jpg')
                                                      as ImageProvider,
                                            ),
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
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.02,
                                            vertical: screenHeight * 0.02),
                                        child: Card(
                                          child: ListTile(
                                            title: Text(articles[index].name),
                                            subtitle: Text(
                                              articles[index].description,
                                              maxLines: 5,
                                            ),
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
                                                  ? NetworkImage(articles[index]
                                                      .urlPicture!)
                                                  : const AssetImage(
                                                          'assets/images/foodtruck.jpg')
                                                      as ImageProvider,
                                            ),
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
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.02,
                                            vertical: screenHeight * 0.02),
                                        child: Card(
                                          child: ListTile(
                                            title: Text(articles[index].name),
                                            subtitle: Text(
                                                articles[index].description),
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
                                                  ? NetworkImage(articles[index]
                                                      .urlPicture!)
                                                  : const AssetImage(
                                                          'assets/images/foodtruck.jpg')
                                                      as ImageProvider,
                                            ),
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
