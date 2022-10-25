import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';
import '../../../models/article_model.dart';
import '../../../service/shootings_api_service.dart';

Widget shootings_tab() {
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Widget customListTile(Article article, BuildContext context) {
  return InkWell(
    onTap: () async {
      Uri url = Uri.parse(article.url ?? "");

      await launchUrl(url, mode: LaunchMode.externalApplication);
    },
    child: Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color.fromARGB(136, 0, 0, 0)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3.0,
            ),
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      article.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                      ),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.42,
                decoration: BoxDecoration(
                  //let's add the height

                  image: DecorationImage(
                      image: NetworkImage(article.urlToImage ?? ""),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Flexible(
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    article.description ?? "",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 95, 94, 94),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                article.source?.name ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  article.publishedAt?.substring(0, 10) ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
