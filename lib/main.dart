import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Response response;
  Dio dio = Dio();

  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  var apidata; //for decoded JSON data
  bool refresh = false; //for forcing refreshing cache

  @override
  void initState() {
    dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: "http://192.168.30.3"))
            .interceptor);
    getData(); //fetching data
    super.initState();
  }

  getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    String url = "http://192.168.30.3/test/?auth=dfvbhdhvchdgcvdchd";

    Response response = await dio.get(url,
        options: buildCacheOptions(
          Duration(days: 7), //duration of cache
          forceRefresh: refresh, //to force refresh
          maxStale: Duration(days: 10), //before this time, if error like
          //500, 500 happens, it will return cache
        ));
    apidata = response.data; //get JSON decoded data from response

    print(apidata); //printing the JSON recieved

    if (response.statusCode == 200) {
      //fetch successful
      if (apidata["error"]) {
        //Check if there is error given on JSON
        error = true;
        errmsg = apidata["msg"]; //error message from JSON
      }
    } else {
      error = true;
      errmsg = "Error while fetching data.";
    }

    loading = false;
    refresh = false;
    setState(() {}); //refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("REST API CACHE SAMPLE"),
          backgroundColor: Color.fromARGB(255, 119, 11, 221),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              refresh = true;
              getData();
            },
            child: SingleChildScrollView(
                child: Container(
                    constraints: BoxConstraints(minHeight: 1500),
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(20),
                    child: loading
                        ? CircularProgressIndicator()
                        : //if loading == true, show progress indicator
                        Container(
                            //if there is any error, show error message
                            child: error
                                ? Text("Error: $errmsg")
                                : Column(
                                    //if everything fine, show the JSON as widget
                                    children:
                                        apidata["data"].map<Widget>((country) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(country["name"]),
                                          subtitle: Text(country["language"]),
                                        ),
                                      );
                                    }).toList(),
                                  ))))));
  }
}
