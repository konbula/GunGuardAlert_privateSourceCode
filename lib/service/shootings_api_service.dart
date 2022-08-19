import 'dart:convert';
import 'package:guntrackattempt1/models/article_model.dart';
import 'package:http/http.dart';

class ApiService {
  final endPointUrl =
      "https://newsapi.org/v2/everything?q=shootings&apiKey=8804b4db9fe64faf9f52ef7c7f6e7d87";

  Future<List<Article>> getArticle() async {
    Response res = await get(Uri.parse(endPointUrl));

    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];

      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();

      return articles;
    } else {
      throw ("Can't get the Articles");
    }
  }
}
