import 'package:flutter/material.dart';

import '../../../models/article_model.dart';
import '../../../service/recent_api_service.dart';

Widget recent_tab() {
  ApiService client = ApiService();
  return FutureBuilder(
    future: client.getArticle(),
    builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
      //let's check if we got a response or not
      if (snapshot.hasData) {
        //Now let's make a list of articles
        List<Article>? articles = snapshot.data;
        return ListView.builder(
          shrinkWrap: true,
          //Now let's create our custom List tile
          itemCount: articles!.length,
          itemBuilder: (context, index) =>
              customListTile(articles[index], context),
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Widget customListTile(Article article, BuildContext context) {
  return InkWell(
    onTap: () {
      print("work on this");
    },
    child: Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3.0,
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              //let's add the height

              image: DecorationImage(
                  image: NetworkImage(article.urlToImage ?? ""),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              article.source?.name ?? "",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            article.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    ),
  );
}
