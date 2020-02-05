import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maga/news_feed/news.dart';
import 'newsItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maga/loader/loader.dart';


class NewsPage extends StatefulWidget {
  @override
  final FirebaseUser user;
  NewsPage(this.user);
  _NewsPageState createState() => _NewsPageState();
  
}

class _NewsPageState extends State<NewsPage> {

  List<News> _items= [];
  bool _isLoading = false;
  bool _isInit = true;

  String currentUser;
  
  Future<void> fetchNews() async{

          _isLoading = true;
 
          const url = 'https://content.guardianapis.com/search?q=australia&tag=environment/recycling&from-date=2018-01-01&show-tags=contributor&show-fields=body,thumbnail,short-url&show-refinements=all&order-by=relevance&api-key=ed144467-d910-464d-93bd-f864c65a3b1c&page-size=50';
          
           final FirebaseAuth auth = FirebaseAuth.instance;
           final FirebaseUser user = await auth.currentUser();
           
          try{
            currentUser = user.email;
            
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
                    content: data['fields']['body'],
                    url:data['webUrl'],
                    user: currentUser
                  ));
              });
            _items = loadedNews;

           // print(_items[0].author);
          }catch(error){
            //throw(error);
            print(error);
          }   
      }

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
      appBar: AppBar(
        title: Text('News Feed'),
      ),
      body: RefreshIndicator(
              onRefresh:() => fetchNews(),
              child: _isLoading ? Loader() :
              ListView.builder(
                itemBuilder: (ctx,index) {
                  return NewsItem(
                    id:_items[index].id,
                    thumbNail: _items[index].thumbNail, 
                    title: _items[index].title, 
                    date: _items[index].date, 
                    author: _items[index].author,
                    content: _items[index].content,
                    url: _items[index].url,
                    user: _items[index].user,
                    );
                },
                itemCount: _items.length,
              ),
      ),
      );
      
      
    
  }
}