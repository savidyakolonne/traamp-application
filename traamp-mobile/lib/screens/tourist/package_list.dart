import 'package:flutter/material.dart';
import 'package:traamp_frontend/widgets/package_card.dart';

// ignore: must_be_immutable
class PackageList extends StatefulWidget {
  List<dynamic> packages = [];
  String uid;
  PackageList(this.packages, this.uid, {super.key});

  @override
  State<PackageList> createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 248, 246),
        title: Text(
          "Recommended For You",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 71, 85, 105)),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 20),
        child: ListView(
          children: [
            // check condition that package array empty or not
            if (widget.packages.isEmpty)
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(child: Text("No Recommendations to Show")),
              )
            else
              for (int i = 0; i < widget.packages.length; i++)
                PackageCard(widget.packages[i], widget.uid),
          ],
        ),
      ),
    );
  }
}
