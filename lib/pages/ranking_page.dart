import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> with SingleTickerProviderStateMixin {
  CollectionReference userProduct = FirebaseFirestore.instance.collection('users');
  CollectionReference rankProduct = FirebaseFirestore.instance.collection('ranking');

  final TextEditingController nameController = TextEditingController();
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> _update(DocumentSnapshot documentSnapshot) async {
  //   nameController.text = documentSnapshot['id'];
  //
  //   await showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (BuildContext context) {
  //         return SizedBox(
  //           child: Padding(
  //             padding: EdgeInsets.all(4),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 TextField(
  //                   controller: nameController,
  //                   decoration: InputDecoration(labelText: 'Name'),
  //                 ),
  //                 SizedBox(
  //                   height: 50,
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     final String name = nameController.text;
  //                     await userProduct.doc(documentSnapshot.id).update({'id': name});
  //                     nameController.text = '';
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('확인'),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // Future<void> _create() async {
  //   await showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (BuildContext context) {
  //         return SizedBox(
  //           child: Padding(
  //             padding: EdgeInsets.all(4),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 TextField(
  //                   controller: nameController,
  //                   decoration: InputDecoration(labelText: 'Name'),
  //                 ),
  //                 SizedBox(
  //                   height: 50,
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     final String name = nameController.text;
  //                     await userProduct.add({'id': name});
  //                     nameController.text = '';
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('확인'),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // Future<void> _delete(String productId) async {
  //   await userProduct.doc(productId).delete();
  // }

  Widget imageProfile() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.question_mark_rounded,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  int? firstGroupValue = 0;
  int? typeGroupValue = 0;
  int? secondGroupValue = 0;
  List typeSymbol = ['+', '-', '×', '÷'];

  final rankIconSize = 10.0;
  List<Color> medalColor = [
    const Color(0xffFFD700),
    const Color(0xffA3A3A3),
    const Color(0xffCD7F32)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('랭킹'), // 종류에 따라 변경. 변수 선언.
      ),
      // dot indicator 추가 예
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              scrollDirection: Axis.horizontal,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CupertinoSlidingSegmentedControl(
                            padding: const EdgeInsets.all(0),
                            groupValue: firstGroupValue,
                            children: {
                              0: Icon(
                                FontAwesomeIcons.one,
                                size: rankIconSize,
                              ),
                              1: Icon(
                                FontAwesomeIcons.two,
                                size: rankIconSize,
                              ),
                              2: Icon(
                                FontAwesomeIcons.three,
                                size: rankIconSize,
                              ),
                              3: Icon(
                                FontAwesomeIcons.four,
                                size: rankIconSize,
                              ),
                            },
                            onValueChanged: (groupValue) {
                              setState(() {
                                firstGroupValue = groupValue as int?;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CupertinoSlidingSegmentedControl(
                            padding: const EdgeInsets.all(0),
                            groupValue: typeGroupValue,
                            children: {
                              0: Icon(
                                FontAwesomeIcons.plus,
                                size: rankIconSize,
                              ),
                              1: Icon(
                                FontAwesomeIcons.minus,
                                size: rankIconSize,
                              ),
                              2: Icon(
                                FontAwesomeIcons.xmark,
                                size: rankIconSize,
                              ),
                              3: Icon(
                                FontAwesomeIcons.divide,
                                size: rankIconSize,
                              ),
                            },
                            onValueChanged: (groupValue) {
                              setState(() {
                                typeGroupValue = groupValue as int?;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CupertinoSlidingSegmentedControl(
                            padding: const EdgeInsets.all(0),
                            groupValue: secondGroupValue,
                            children: {
                              0: Icon(
                                FontAwesomeIcons.one,
                                size: rankIconSize,
                              ),
                              1: Icon(
                                FontAwesomeIcons.two,
                                size: rankIconSize,
                              ),
                              2: Icon(
                                FontAwesomeIcons.three,
                                size: rankIconSize,
                              ),
                              3: Icon(
                                FontAwesomeIcons.four,
                                size: rankIconSize,
                              ),
                            },
                            onValueChanged: (groupValue) {
                              setState(() {
                                secondGroupValue = groupValue as int?;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('yyyy년 MM월 dd일 HH시 mm분 기준 ').format(DateTime.now()),
                      style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.start,
                    ),
                    Flexible(
                      child: StreamBuilder(
                        stream: rankProduct
                            .where("type",
                                isEqualTo:
                                    '${typeSymbol[typeGroupValue!]}[${firstGroupValue! + 1}, ${secondGroupValue! + 1}]')
                            .orderBy('score')
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasError) {
                            print(streamSnapshot.error);
                            return Text('error!');
                          } else if (streamSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return ListView.builder(
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  //print(documentSnapshot['id']);
                                  //print(documentSnapshot['score']);
                                  return Card(
                                    color: Colors.white.withOpacity(0.85),
                                    surfaceTintColor: Colors.white,
                                    child: ListTile(
                                      leading: Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        //alignment: WrapAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 25,
                                            child: Text(
                                              '${(index + 1)}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color:
                                                      index >= 3 ? Colors.black : medalColor[index],
                                                  fontWeight: index >= 3
                                                      ? FontWeight.normal
                                                      : FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          imageProfile(),
                                        ],
                                      ),
                                      title: Text(documentSnapshot['name'].toString()),
                                      //subtitle: Text(documentSnapshot['exp'].toString()),
                                      trailing: Text('${documentSnapshot['score']} s'),
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  // 총 경험치 랭킹
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        DateFormat('yyyy년 MM월 dd일 HH시 mm분 기준').format(DateTime.now()),
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Flexible(
                      //     flex: 10,
                      child: StreamBuilder(
                        stream: userProduct.orderBy('exp', descending: true).snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return ListView.builder(
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  //print(documentSnapshot['id']);
                                  //print(documentSnapshot['score']);
                                  return Card(
                                    color: Colors.white.withOpacity(0.85),
                                    surfaceTintColor: Colors.white,
                                    child: ListTile(
                                      leading: Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        //alignment: WrapAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 25,
                                            child: Text(
                                              '${(index + 1)}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color:
                                                      index >= 3 ? Colors.black : medalColor[index],
                                                  fontWeight: index >= 3
                                                      ? FontWeight.normal
                                                      : FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          imageProfile(),
                                        ],
                                      ),
                                      title: Text(documentSnapshot['name'].toString()),
                                      //subtitle: Text(documentSnapshot['exp'].toString()),
                                      trailing: Text('${documentSnapshot['exp']} exp'),
                                    ),
                                  );
                                });
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 2; i++)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      width: i == _currentPage ? 12 : 8,
                      height: i == _currentPage ? 12 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _currentPage ? Theme.of(context).primaryColor : Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
