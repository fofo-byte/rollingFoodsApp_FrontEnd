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

  void showArticleDialog(BuildContext context, Article article, Function onEdit,
      Function onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Action pour ${article.name}'),
          content: const Text('Que voulez-vous faire?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
                onEdit(); // Appeler la fonction de modification
              },
              child: const Text('Modifier'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
                onDelete(); // Appeler la fonction de suppression
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
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
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.all(10)),
          const Center(
            child: Text(
              textAlign: TextAlign.center,
              'Vous pouvez modifier ou supprimer vos articles ici.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            endIndent: 20,
            indent: 20,
            thickness: 2,
          ),
          const Padding(padding: EdgeInsets.all(10)),
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
                        onTap: () {
                          showArticleDialog(
                            context,
                            snapshot.data![index],
                            () {
                              // Edit
                              Navigator.pushNamed(context, '/editArticle',
                                  arguments: snapshot.data![index]);
                            },
                            () {
                              // Delete
                              ArticleService()
                                  .deleteArticle(snapshot.data![index].id);
                              setState(() {
                                articles =
                                    ArticleService().getItemsByFoodTruckId();
                              });
                            },
                          );
                        },
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
