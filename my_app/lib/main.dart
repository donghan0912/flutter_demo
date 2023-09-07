import 'package:flutter/material.dart';
import 'package:my_app/module/test/row_multi_list_view_demo.dart';

import 'module/nest_tab_bar/nest_tab_bar_demo.dart';
import 'module/nest_tab_bar/nest_tab_bar_demo2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // highlightColor、splashColor，全局解决按钮等点击水波纹效果
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // 注意：useMaterial3设置为ture，一直发现的bug是TabBar dividerColor: Colors.transparent,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  NestTabBarDemo()),);
            }, child: Text('333')),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  NestTabBarDemo2()),);
            }, child: Text('444')),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  RowMultiListViewDemo()),);
            }, child: Text('测试关注页面')),


          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
