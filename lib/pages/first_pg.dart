import 'package:flutter/material.dart';
import 'package:sop/pages/vr_home_pg.dart';

class First_Page extends StatefulWidget {
  const First_Page({Key? key}) : super(key: key);

  @override
  State<First_Page> createState() => _First_PageState();
}

class _First_PageState extends State<First_Page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
            end:Alignment.bottomRight,
          colors: [Color.fromRGBO(127, 127, 213, 1), Color.fromRGBO(138, 168, 231, 1), Color.fromRGBO(145, 234, 228, 1)]
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 70,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomePage()));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)
                          ),
                        ),
                        child: Text("Voice Commands",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25
                            )
                        )),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: SizedBox(
                    height: 70,
                    child: ElevatedButton(
                        onPressed: () {
                          var snackBar = SnackBar(content: Text('Feature in development'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)
                          ),
                        ),
                        child: Text("Text Recognition",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25
                        )
                          )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
