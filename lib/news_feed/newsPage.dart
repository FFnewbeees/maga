import 'dart:convert';
import 'newsItem.dart';
import 'package:flutter/material.dart';
import 'package:maga/news_feed/newsDetail.dart';
import 'newsItem.dart';
import 'package:http/http.dart' as http;


class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  List<NewsItem> _items= [];

  @override               
    void initState(){
        //1. fetching api for news list
        Future<void> fetchNews() async{
          const url = 'https://newsapi.org/v2/everything?q=australia recycling waste&from=2019-12-13&to=2020-01-12&sortBy=relevancy&apiKey=431886ee5bc44afe854fbbe6a37747ff';
          try{
          
          final response = await http.get(url);
          final data = json.decode(response.body) as Map<String, dynamic>;

          final List<NewsItem> loadedNews = [];
          data.forEach((articles, newsData){
            loadedNews.add(NewsItem(
              title: newsData['title'],
              description: newsData['description'],
              author: newsData['author'],
              date: newsData['publishedAt'],
              url: newsData['url'],
              thumbNail: newsData['urlToImage'],
            ));
          });
          _items = loadedNews;
          print(jsonDecode(response.body));
          }catch(error){
            //add a loading indicator
            // throw(error);
            print(error);
          }
      }

      fetchNews();
      super.initState();
      
    }


  @override
  Widget build(BuildContext context) {
    final Color bgColor = Color(0xffF3F3F3);
    final Color primaryColor = Color.fromRGBO(0, 102, 204, 0.3);

    // var titleTextStyle = TextStyle(
    //   color: Colors.black87,
    //   fontSize: 20.0
    // );
    // var teamNameTextStyle = TextStyle(
    //                           fontSize: 18.0,
    //                           fontWeight: FontWeight.w500,
    //                           color: Colors.grey.shade800,
    //                         );

    

    return Container(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Center(
              child: ToggleButtons(
                fillColor: primaryColor,
                hoverColor: primaryColor,
                renderBorder: true,
                borderRadius: BorderRadius.circular(10.0),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.av_timer),
                        SizedBox(height: 16.0),
                        Text(
                          "Latest News",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.public),
                        SizedBox(height: 16.0),
                        Text("Recycle News",
                        )
                      ],
                    ),
                  ),
                  
                ],
                isSelected: [
                  true,
                  false,
                  
                ],
                onPressed: (index){},
              ),
            ),
            SizedBox(height: 16.0),
            //place news item here
            GestureDetector(
              child: NewsItem(),
              onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => NewsDetail(),
                      )); 
                  },
            ),
            SizedBox(height: 10.0),
            Divider(),
            SizedBox(height: 10.0),
          ],
          ),
      );
      
      
    
  }
}