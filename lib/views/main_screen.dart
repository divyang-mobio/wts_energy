import 'package:flutter/material.dart';
import 'package:wts_energy/views/safe_screen.dart';

import '../resources/resources.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset('assets/logo.png', height: 120),
        actions: [
          PopupMenuButton<String>(
            onSelected: (s) {},
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: "choice",
                  child: Text("Logout"),
                )
              ];
            },
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey,
          height: 40,
          child: const Center(child: Text('Last synced 2023-01-16')),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                color: Colors.red,
                height: MediaQuery.of(context).size.height * .26,
                width: MediaQuery.of(context).size.width,
              ),
              Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .23,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: Text(
                      '''Toolbox Suite
Enhance your field
potential''',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 4 / 3),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SafeScreen()));
                      },
                      child: Card(
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(data[index].image, height: 50),
                                const SizedBox(height: 10),
                                Text(data[index].title)
                              ]),
                        ),
                      ),
                    );
                  },
                )
              ])
            ]),
          ],
        ),
      ),
    );
  }
}
