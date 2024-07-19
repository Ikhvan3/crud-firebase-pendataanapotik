import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/crudfurniture.dart';

import 'package:flutter_application_1/screens/pelangganscreen.dart';

class AppPendataan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topRight,
                  colors: [
                Color.fromARGB(255, 174, 255, 242),
                // Color.fromARGB(255, 46, 220, 255),
                Color.fromARGB(255, 174, 255, 242),
              ])),
          child: Column(
            children: [
              Card(
                elevation: 2,
                color: Color.fromARGB(255, 2, 210, 252),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topRight,
                        colors: [
                          Color.fromARGB(255, 2, 210, 252),
                          Color.fromARGB(255, 0, 255, 213),
                        ]),
                  ),
                  height: 150,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Image(
                          height: 130,
                          width: 120,
                          image: AssetImage("images/logo_furniture.png"),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 45, right: 25),
                        child: Column(
                          children: [
                            Text(
                              "FURNITURE ",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 251, 251, 251),
                              ),
                            ),
                            Text(
                              "Let’s Make Your Home Special",
                              style: TextStyle(
                                fontSize: 17,
                                // fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                elevation: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                            colors: [
                          Color.fromARGB(255, 2, 210, 252),
                          Color.fromARGB(255, 0, 255, 213),

                          // Color.fromARGB(255, 227, 227, 227),
                          // const Color.fromARGB(255, 150, 150, 150)
                        ])),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 380,
                            height: 180,
                            child: Image(
                              image: AssetImage("images/bg1_furniture.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            width: 380,
                            height: 180,
                            child: Image(
                              image: AssetImage("images/bg2_furniture.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Builder(
                    builder: (context) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PendataanBarangFurniture(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 0, 145, 174),
                                  blurRadius: 20,
                                  blurStyle: BlurStyle.inner,
                                  offset: Offset(4, 4),
                                  spreadRadius: BorderSide.strokeAlignOutside,
                                )
                              ],
                              borderRadius: BorderRadius.circular(20),
                              gradient: RadialGradient(colors: [
                                Color.fromARGB(255, 0, 255, 213),
                                Color.fromARGB(255, 2, 210, 252),
                              ])),
                          margin: EdgeInsets.only(left: 30),
                          height: 170,
                          width: 160,
                          child: Column(
                            children: [
                              Image(
                                height: 120,
                                image:
                                    AssetImage("images/logo_menu_barang.png"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 0, 157, 131),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "PENDATAAN \n   BARANG",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PendataanPelangganFurniture(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 0, 145, 174),
                                  blurRadius: 20,
                                  blurStyle: BlurStyle.inner,
                                  offset: Offset(4, 4),
                                  spreadRadius: BorderSide.strokeAlignOutside,
                                )
                              ],
                              borderRadius: BorderRadius.circular(20),
                              gradient: RadialGradient(colors: [
                                Color.fromARGB(255, 0, 255, 213),
                                Color.fromARGB(255, 2, 210, 252),
                              ])),
                          margin: EdgeInsets.only(left: 30),
                          height: 170,
                          width: 160,
                          child: Column(
                            children: [
                              Image(
                                height: 120,
                                image: AssetImage("images/penggunaa.png"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 0, 157, 131),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                alignment: Alignment.center,
                                height: 40,
                                width: 160,
                                child: Text(
                                  "PENDATAAN PELANGGAN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
