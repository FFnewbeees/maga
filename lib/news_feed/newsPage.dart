import 'dart:convert';
import 'package:maga/news_feed/news.dart';
import 'newsItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maga/loader/loader.dart';


class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  List<News> _items= [];
  bool _isLoading = false;
  bool _isInit = true;
  
  @override               
    void initState(){

    super.initState();
      
    }

  @override
    void didChangeDependencies() {
      
      if(_isInit){
        setState(() {
          _isLoading = true;
        });
         //1. fetching api for news list

        Future<void> fetchNews() async{

          _isLoading = true;
 
          const url = 'https://content.guardianapis.com/search?q=australia&tag=environment/recycling&from-date=2018-01-01&show-tags=contributor&show-fields=body,thumbnail,short-url&show-refinements=all&order-by=relevance&api-key=ed144467-d910-464d-93bd-f864c65a3b1c&page-size=50';
          
          try{
            final response = await http.get(url);

            final data = json.decode(utf8.decode(response.bodyBytes));
           
            final articleData = data['response']['results'] as List<dynamic>;

            final List<News> loadedNews = [];
            
              articleData.forEach((data) {
                loadedNews.add(
                  News(
                    id:data['id'],
                    thumbNail: data['fields']['thumbnail'],
                    title: data['webTitle'],
                    date: data['webPublicationDate'],
                    author: data['tags'][0]['webTitle'],
                    content: data['fields']['body']
                  ));
              });
            _items = loadedNews;

           // print(_items[0].author);
          }catch(error){
            //throw(error);
            print(error);
          }   
      }

      fetchNews().then((_){
        setState(() {
           _isLoading = false;
        });
      });
      }

      _isInit = false;
      super.didChangeDependencies();
    }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      body: _isLoading ? Loader() :
            ListView.builder(
              itemBuilder: (ctx,index) {
                return NewsItem(
                  id:_items[index].id,
                  thumbNail: _items[index].thumbNail, 
                  title: _items[index].title, 
                  date: _items[index].date, 
                  author: _items[index].author,
                  content: _items[index].content,
                  );
              },
              itemCount: _items.length,
            ),
      );
      
      
    
  }
}