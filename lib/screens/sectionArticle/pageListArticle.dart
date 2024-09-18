import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/models/article.dart';
import 'package:rolling_foods_app_front_end/services/article_service.dart';

class Pagelistarticle extends StatefulWidget {
  const Pagelistarticle({super.key});

  @override
  State<Pagelistarticle> createState() => _PagelistarticleState();
}

class _PagelistarticleState extends State<Pagelistarticle> {
  late Future<List<Article>> articles;

  @override
  void initState() {
    super.initState();
    articles = ArticleService().getItemsByFoodTruckId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des articles'),
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        children: [
          FutureBuilder(
            future: articles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data?[index].name ?? ''),
                        subtitle: Text(snapshot.data?[index].description ?? ''),
                        trailing:
                            Text(snapshot.data?[index].price.toString() ?? ''),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          )
        ],
      ))),
      //Show list of articles
    );
  }
}
