import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/crudbarangscreen.dart';

import 'crudobarscreen.dart';

class AppPendataan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Container(
              height: 150,
              color: Color.fromARGB(255, 66, 222, 207),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Image(
                      height: 110,
                      width: 90,
                      image: AssetImage("images/logo3_apotik.png"),
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
                          "APOTIK FARMA",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Where Health Meets Hope",
                          style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                color: Colors.blueGrey,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        width: 390,
                        child: Image(
                          image: AssetImage("images/bg_apotik.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        width: 390,
                        child: Image(
                          image: AssetImage("images/bg2_apotik.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
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
                            builder: (context) => CrudPage(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 30),
                        height: 170,
                        width: 160,
                        color: Color.fromARGB(255, 66, 222, 207),
                        child: Column(
                          children: [
                            Image(
                              height: 120,
                              image: AssetImage("images/menu_obat.png"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 160,
                              color: Colors.blueGrey,
                              child: Text(
                                "PENDATAAN OBAT",
                                style: TextStyle(
                                  fontSize: 15,
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
                            builder: (context) => CrudPageBarang(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 30),
                        height: 170,
                        width: 160,
                        color: Color.fromARGB(255, 66, 222, 207),
                        child: Column(
                          children: [
                            Image(
                              height: 120,
                              image: AssetImage("images/menu_konsultasi.png"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 160,
                              color: Colors.blueGrey,
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
    );
  }
}
