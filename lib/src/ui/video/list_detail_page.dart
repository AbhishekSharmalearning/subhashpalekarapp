import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

class ListDetailPage extends StatefulWidget {
  final listHeading;

  const ListDetailPage({
    Key? key,
    @PathParam() required this.listHeading
  }) : super(key: key);

  @override
  State<ListDetailPage> createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  @override
  Widget build(BuildContext context) {
    late String heading;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: widget.listHeading.length,
                  itemBuilder: (context,index){
                    for(int i=0;i<widget.listHeading.length;i++){
                      heading = widget.listHeading[i]['heading'];
                    }
                    return GestureDetector(
                      child: Container(
                        height: 70,
                        child: Card(
                          elevation: 10,
                          child: Chip(
                            label: Text(heading),
                            shadowColor: Colors.blue,
                            backgroundColor: Colors.green,
                            elevation: 5,
                            autofocus: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

