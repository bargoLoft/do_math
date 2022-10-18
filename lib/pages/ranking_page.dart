import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  CollectionReference product = FirebaseFirestore.instance.collection('ranking');

  final TextEditingController nameController = TextEditingController();

  Future<void> _update(DocumentSnapshot documentSnapshot) async {
    nameController.text = documentSnapshot['id'];

    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final String name = nameController.text;
                      await product.doc(documentSnapshot.id).update({'id': name});
                      nameController.text = '';
                      Navigator.pop(context);
                    },
                    child: Text('확인'),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _create() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final String name = nameController.text;
                      await product.add({'id': name});
                      nameController.text = '';
                      Navigator.pop(context);
                    },
                    child: Text('확인'),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await product.doc(productId).delete();
  }

  int? firstGroupValue = 0;
  int? typeGroupValue = 0;
  int? secondGroupValue = 0;
  final rankIconSize = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('랭킹'),
      ),
      body: Column(
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
            '2022년 10월 22일 PM 10:00 기준  ',
            style: TextStyle(fontSize: 10),
            textAlign: TextAlign.start,
          ),
          Flexible(
            child: StreamBuilder(
              stream: product.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                        print(documentSnapshot['id']);
                        print(documentSnapshot['score']);
                        return Card(
                          child: ListTile(
                            title: Text(documentSnapshot['id'].toString()),
                            subtitle: Text(documentSnapshot['score'].toString()),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      _update(documentSnapshot);
                                    },
                                    icon: Icon(Icons.edit),
                                  )
                                ],
                              ),
                            ),
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
    );
  }
}
