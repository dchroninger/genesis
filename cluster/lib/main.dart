import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: CupertinoColors.darkBackgroundGray,
          body: Center(
            child: SizedBox(
              height: 900,
              width: 1300,
              child: Column(
                children: [
                  // Primary Cluster Display Container
                  Container(
                    height: 700,
                    width: 1300,
                    decoration: const BoxDecoration(
                        color: CupertinoColors.tertiaryLabel),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        Container(
                            height: 600,
                            width: 1300,
                            decoration: const BoxDecoration(
                                color: CupertinoColors.black),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'This is where the main cluster will be rendered',
                                style: TextStyle(color: CupertinoColors.white),
                              ),
                            )),
                        Container(
                            height: 60,
                            width: 1300,
                            decoration: const BoxDecoration(
                                color: CupertinoColors.systemGrey),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                  'Auxilary informaiton can be displayed here. Things like mileage.'),
                            ))
                      ]),
                    ),
                  ),
                  // Development control panel
                  Container(
                      height: 200,
                      width: 1300,
                      decoration: const BoxDecoration(
                          color: CupertinoColors.darkBackgroundGray),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Test input controls will go here',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
