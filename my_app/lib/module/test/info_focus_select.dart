import 'package:flutter/material.dart';
import 'package:my_app/widget/row_multi_list_view.dart';


class InfoFocusSelect extends StatefulWidget {


  InfoFocusSelect({super.key,});

  @override
  State<StatefulWidget> createState() => InfoFocusSelectState();
}


class InfoFocusSelectState extends State<InfoFocusSelect> {
  Map<String, String> resultMap = {};

  List<int> listViewsItemCount = [26];



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // TODO 在返回的时候，判断是否为异常数据，因为可能牵扯到数据保存到本地


    return Scaffold(
      appBar: AppBar(
        title: Text('选择专业'),
      ),
      body: RowMultiListView(
        listViewCount: 2,
        listViewWidths: const [120, null],
        listViewItemCounts: listViewsItemCount,
        listViewItemBuilders: (isSelected, listViewIndex, index){
          return _getItemWidget(isSelected, listViewIndex, index);
        },
        onItemClick: (isRepeatedClick, listViewIndex, clickedIndexes){
          clickedIndexes.forEach((element) {
            print('第$listViewIndex个ListView的点击位置$element === 重复点击：$isRepeatedClick');
          });


          if(listViewIndex == 0) {
            setState(() {

              listViewsItemCount = [26, 48];
            });
          } else {
            setState(() {

              listViewsItemCount = [26, 48, 70];
            });
          }



        },

      ),
    );
  }

  Widget _getItemWidget(bool isSelected, int listViewIndex, int index) {

    List<Widget> list = [];
    Widget item;
    if (listViewIndex == 0) {
     item = Container(
       color: isSelected ? Colors.black.withAlpha(20) : Colors.white,
       child: ListTile(
          title: Text('Item 6', style: TextStyle(color: isSelected ? Colors.red : Colors.black,),

        )),
     );
    } else if (listViewIndex == 1) {
       item = Container(
         color: isSelected ? Colors.black.withAlpha(20) : Colors.white,
         child: ListTile(
              title: Text('Item 8', style: TextStyle(color: isSelected ? Colors.red : Colors.black,),

              )),
       );
      } else {
       item = Container(
         color: isSelected ? Colors.black.withAlpha(20) : Colors.white,
         child: ListTile(
          title: Text('Item 10', style: TextStyle(color: isSelected ? Colors.red : Colors.black,),

          )),
       );
    }

    list.add(widget);

    return item;
  }


}


/*class InfoFocusSelectState extends State<InfoFocusSelect> {
  Map<String, String> resultMap = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // TODO 在返回的时候，判断是否为异常数据，因为可能牵扯到数据保存到本地

    return Scaffold(
      appBar: AppBar(
        title: Text('选择专业'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200,),
            TextButton(
              onPressed: () {
                resultMap['name'] = '北京大学';
                resultMap['code'] = '001';
                Navigator.pop(context, resultMap);
              },
              child: Text('院校返回数据'),
            ),
            TextButton(
              onPressed: () {
                resultMap['name'] = '清华大学';
                resultMap['code'] = '002';
                Navigator.pop(context, resultMap);
              },
              child: Text('院校返回数据'),
            ),
            TextButton(
              onPressed: () {
                resultMap['name'] = '数学';
                resultMap['code'] = '01';
                Navigator.pop(context, resultMap);
              },
              child: Text('专业返回数据'),
            ),
            TextButton(
              onPressed: () {
                resultMap['name'] = '物理';
                resultMap['code'] = '02';
                Navigator.pop(context, resultMap);
              },
              child: Text('专业返回数据'),
            ),
          ],
        ),
      ),
    );
  }
}*/
