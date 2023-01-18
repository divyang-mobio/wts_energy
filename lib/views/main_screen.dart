import 'package:flutter/material.dart';
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
      backgroundColor: ColorResources().mainScreenBGColor,
      appBar: AppBar(
        backgroundColor: ColorResources().mainScreenAppBarColor,
        centerTitle: true,
        title: Image.asset(AssetImageLink().mainScreenLogoImage, height: 120),
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
          color: ColorResources().syncBarBGColor,
          height: 40,
          child: Center(child: Text(TextResources().syncString)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * .26,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(AssetImageLink().mainScreenBGImage,
                      fit: BoxFit.cover)),
              Container(
                  color: ColorResources().mainScreenImageDarkenColor,
                  height: MediaQuery.of(context).size.height * .26,
                  width: MediaQuery.of(context).size.width),
              Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .23,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      TextResources().headTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: ColorResources().headTileColor),
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
                      onTap: () =>
                          Navigator.pushNamed(context, RouteName().safeScreen),
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
