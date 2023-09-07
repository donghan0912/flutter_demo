import 'package:flutter/material.dart';
import 'package:my_app/widget/common_app_bar.dart';
import 'package:my_app/widget/row_multi_list_view.dart';

/// 超学考研资讯 ‘添加关注专业’弹框
// ignore: must_be_immutable
class RowMultiListViewDemo extends StatefulWidget {
  /// 选中数据，name和'code'
  Map<String, String>? resultMap;

  RowMultiListViewDemo({super.key, this.resultMap});

  @override
  State<StatefulWidget> createState() => RowMultiListViewDemoState();
}

class RowMultiListViewDemoState extends State<RowMultiListViewDemo> {
  /// 弹框第一列数据
  List<String> subjectList1 = [];

  /// 弹框第二列数据
  List<String> subjectList2 = [];

  /// 弹框第三列数据
  List<String> subjectList3 = [];

  /// 每列ListView的数据个数
  List<int> listViewsItemCount = [];

  /// 不能点击index集合（这里只有第二列有这种情况，后续其它列，可把ListView位置带上）
  List<int> unableClickIndexes = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 10; i++) {
      subjectList1.add('第1列第$i条');
    }
    listViewsItemCount = [subjectList1.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: '水平多列选择器',
      ),
      body: RowMultiListView(
        listViewCount: 3,
        listViewWidths: const [100, 100, null],
        listViewItemCounts: listViewsItemCount,
        listViewItemBuilders: (isSelected, listViewIndex, index) {
          return _getItemWidget(isSelected, listViewIndex, index);
        },
        listViewBgColors: const [null, Color(0x1A407BFF), Color(0x1A407BFF)],
        itemClickable: (listViewIndex, index) {
          /// 这里给出是否可点击
          if (listViewIndex == 1) {
            return !unableClickIndexes.contains(index);
          }
          return true;
        },
        onItemClick: (isRepeatedClick, listViewIndex, clickedIndexes, index) {
          /// 忽略'重复点击'操作
          if (isRepeatedClick) {
            return;
          }
          if (listViewIndex == 0) {
            var graduateMasterSubjects = getGraduateMasterSubjects(index);
            var graduateMasterSpeSubjects = getGraduateSpeSubjects(index);
            Future.wait([graduateMasterSubjects, graduateMasterSpeSubjects])
                .then((value) {
              subjectList2.clear();
              unableClickIndexes.clear();
              var subject1 = '学术硕士';
              var subject2 = '专业硕士';
              var list1 = value[0];
              var list2 = value[1];
              if (list1.isNotEmpty) {
                list1.insert(0, subject1);
                subjectList2.addAll(list1);

                /// 记录不能点击index
                unableClickIndexes.add(0);
              }
              if (list2.isNotEmpty) {
                /// 记录不能点击index
                unableClickIndexes.add(subjectList2.length);
                list2.insert(0, subject2);
                subjectList2.addAll(list2);
              }
            }).whenComplete(() {
              setState(() {
                listViewsItemCount = [
                  subjectList1.length,
                  subjectList2.length
                ];
              });
            });
          } else if (listViewIndex == 1) {
            getGraduateSubjects(index).then((value) {
              setState(() {
                subjectList3 = value;
                listViewsItemCount = [
                  subjectList1.length,
                  subjectList2.length,
                  subjectList3.length
                ];
              });
            });
          } else {
            setState(() {});
          }
          _setData(clickedIndexes);
        },
      ),
    );
  }

  /// 保存用户已选中数据
  /// [clickedIndexes] 每个listView被选中的index，-1为默认值
  /// 注：专业选择，总共三列，只要用户选中其中一列，数据就有效，所以这里采用倒序遍历
  _setData(List<int> clickedIndexes) {
    widget.resultMap ??= {};
    List<String> tempList;
    for (int i = clickedIndexes.length - 1; i >= 0; i--) {
      var element = clickedIndexes[i];
      if (element > -1) {
        if (i == 2) {
          tempList = subjectList3;
        } else if (i == 1) {
          tempList = subjectList2;
        } else {
          tempList = subjectList1;
        }
        widget.resultMap!['name'] = tempList[element];
        break;
      }
    }
  }

  /// 每列ListView的Item布局
  Widget _getItemWidget(bool isSelected, int listViewIndex, int index) {
    Widget item;
    if (listViewIndex == 0) {
      item = Container(
        height: 44,
        color: isSelected ? const Color(0x334DA7FF) : const Color(0xFF17214D),
        child: Row(
          children: [
            Visibility(
                visible: isSelected,
                maintainAnimation: true,
                maintainSize: true,
                maintainState: true,
                child: Container(
                  height: 44,
                  width: 2,
                  color: const Color(0xFF00DDFF),
                )),
            const SizedBox(
              width: 8,
            ),
            Text(subjectList1[index],
                style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 14)),
          ],
        ),
      );
    } else if (listViewIndex == 1) {
      bool isTitle = unableClickIndexes.contains(index);
      item = Container(
        height: 44,
        color: isTitle
            ? const Color(0x0A407BFF)
            : isSelected
                ? const Color(0x334DA7FF)
                : const Color(0x1A407BFF),
        child: Row(
          children: [
            Visibility(
                visible: isSelected && !isTitle,
                maintainAnimation: true,
                maintainSize: true,
                maintainState: true,
                child: Container(
                  height: 44,
                  width: 2,
                  color: const Color(0xFF00DDFF),
                )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text(subjectList2[index],
                    style: TextStyle(
                        color: isTitle ? const Color(0xFF00DDFF) : Colors.white,
                        fontSize: 14))),
          ],
        ),
      );
    } else {
      item = Container(
        height: 44,
        color: isSelected ? const Color(0x334DA7FF) : const Color(0x1A407BFF),
        child: Row(
          children: [
            Visibility(
                visible: isSelected,
                maintainAnimation: true,
                maintainSize: true,
                maintainState: true,
                child: Container(
                  height: 44,
                  width: 2,
                  color: const Color(0xFF00DDFF),
                )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text(subjectList3[index],
                    style: const TextStyle(
                        color: Color(0xFFFFFFFF), fontSize: 14))),
          ],
        ),
      );
    }
    return item;
  }

  /// 学硕
  Future<List<String>> getGraduateMasterSubjects(int pIndex) {
    return Future(() {
      return List.generate(5, (index) => '第$pIndex行 学硕$index');
    });
  }

  /// 专硕
  Future<List<String>> getGraduateSpeSubjects(int pIndex) {
    return Future(() {
      return List.generate(7, (index) => '第$pIndex行 专硕$index');
    });
  }

  /// 获取具体学科
  Future<List<String>> getGraduateSubjects(int pIndex) {
    return Future(() {
      return List.generate(9, (index) => '第$pIndex行 学科$index');
    });
  }
}
