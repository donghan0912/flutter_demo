import 'package:flutter/material.dart';
import 'package:my_app/module/test/info_focus_select.dart';

class InfoFocusCollegesMajorsPage extends StatefulWidget {
  const InfoFocusCollegesMajorsPage({super.key});

  @override
  State<StatefulWidget> createState() => InfoFocusCollegesMajorsPageState();
}

const focusCollegeHintName = '最多关注两个院校';

class InfoFocusCollegesMajorsPageState
    extends State<InfoFocusCollegesMajorsPage> {


  /// ‘最多关注两个专业’按钮数据
  final focusCollegeHintData = FocusData(type: FocusType.add, name: focusCollegeHintName);
  /// ‘最多关注两个专业’按钮数据
  final focusMajorHintData = FocusData(type: FocusType.add, name: '最多关注两个专业');
  /// 关注院校列表数据
  List<FocusData> collegeList = [];
  /// 关注专业列表数据
  List<FocusData> majorList = [];

  /// 点击跳转选择院校/专业页面时的数据，用来判断是更新数据还是新增数据
  late FocusData clickFocusData;

  @override
  void initState() {
    super.initState();

    collegeList.add(focusCollegeHintData);
    majorList.add(focusMajorHintData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关注设置'),
      ),
      body: Column(
        children: [
          _getTitleWidget('关注学校'),
          _getListView(collegeList),
          _getTitleWidget('关注专业'),
          _getListView(majorList),
        ],
      ),
    );
  }

  Widget _getTitleWidget(String data) {
    return Text(
      data,
      style: TextStyle(color: Color(0xFF262626)),
    );
  }

  Widget _getListView(List<FocusData> list) {
    return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var item = list[index];
          if (item.type == FocusType.add) {
            return getAddWidget(item);
          }
          return _getSelectedWidget(item);
        },
        itemCount: list.length);
  }

  /// 选中院校、专业组件
  Widget _getSelectedWidget(FocusData data) {
    return InkWell(
      onTap: () {
        clickFocusData = data;
        _pushSelect();
      },
      child: Container(
        width: double.infinity,
        height: 40,
        margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Text(
              data.name ?? '',
              textAlign: TextAlign.center,
            ),
            Positioned(
              right: 20,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      if (data.type == FocusType.college) {
                        if (!collegeList.contains(focusCollegeHintData)) {
                          collegeList.add(focusCollegeHintData);
                        }
                        collegeList.remove(data);
                      } else {
                        if (!majorList.contains(focusMajorHintData)) {
                          majorList.add(focusMajorHintData);
                        }
                        majorList.remove(data);
                      }
                    });
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.red,
                  )),
            )
          ],
        ),
      ),
    );
  }

  /// 新增关注按钮组件
  Widget getAddWidget(FocusData data) {
    return InkWell(
      onTap: () {
        clickFocusData = data;
        _pushSelect();
      },
      child: Container(
        width: double.infinity,
        height: 40,
        margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Text(
              data.name ?? '',
              textAlign: TextAlign.center,
            ),
            Positioned(
              left: 20,
              child: Container(
                height: 30,
                width: 30,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 刷新数据
  /// [result] 关注院校/专业页面返回后的数据，Map类型
  void updateData(dynamic result) {
    Map<String, String> resultMap = result;
    var resultName = resultMap['name'];
    var resultCode = resultMap['code'];
    setState(() {
      /// 新增数据
      if (clickFocusData.type == FocusType.add) {
        if (clickFocusData.name == focusCollegeHintName) {
          var focusData = FocusData(type: FocusType.college, name: resultName, code: resultCode);
          if (collegeList.length == 2) {
            collegeList[1] = focusData;
          } else {
            collegeList.insert(0, focusData);
          }
        } else {
          var focusData = FocusData(type: FocusType.major, name: resultName, code: resultCode);
          if (majorList.length == 2) {
            majorList[1] = focusData;
          } else {
            majorList.insert(0, focusData);
          }
        }
      } else {
        /// 更新数据
        if (clickFocusData.type == FocusType.college) {
          var focusData = FocusData(type: FocusType.college, name: resultName, code: resultCode);
          var indexOf = collegeList.indexOf(clickFocusData);
          if (indexOf >= 0) {
            collegeList[indexOf] = focusData;
          }
        } else {
          var focusData = FocusData(type: FocusType.major, name: resultName, code: resultCode);
          var indexOf = majorList.indexOf(clickFocusData);
          if (indexOf >= 0) {
            majorList[indexOf] = focusData;
          }
        }
      }
    });
  }

  /// 跳转选择院校、专业页面
  // TODO 改名
  void _pushSelect() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfoFocusSelect( )),
    ).then((value) => updateData(value));
  }
}

enum FocusType {
  college,
  major,
  add,
}

class FocusData {
  final String? name;
  final String? code;
  final FocusType type;

  FocusData({this.name, this.code, required this.type});
}
