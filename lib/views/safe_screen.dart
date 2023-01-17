import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/data_model.dart';

class SafeScreen extends StatefulWidget {
  const SafeScreen({Key? key}) : super(key: key);

  @override
  State<SafeScreen> createState() => _SafeScreenState();
}

class _SafeScreenState extends State<SafeScreen> {
  SafeModel? safeModel;

  @override
  void initState() {
    super.initState();
    jsonConverter();
  }

  Future<void> jsonConverter() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/Safe.json");
    final jsonResult = jsonDecode(data);
    safeModel = SafeModel.fromJson(jsonResult);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return safeModel == null
        ? const Scaffold(body: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(safeModel?.title ?? "",
                  style: const TextStyle(color: Colors.white)),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor:
                  Color(int.parse("0xff${safeModel?.color ?? 'ffff'}")),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: safeModel?.properties?.length,
                      itemBuilder: (context, index) => (safeModel
                                  ?.properties?[index].type ==
                              "options")
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ListTile(
                                leading: Icon(iconData[index], size: 35),
                                shape: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5)),
                                title: Text(
                                  safeModel?.properties?[index].title ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text(
                                //     safeModel?.properties?[index].hint ?? ""),
                                subtitle: SizedBox(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: Text(
                                          safeModel?.properties?[index].hint ??
                                              ""),
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: safeModel
                                          ?.properties?[index].options
                                          ?.map((items) {
                                        return DropdownMenuItem(
                                          value: items.title,
                                          child: Text(items.title.toString(),
                                              overflow: TextOverflow.clip),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {},
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : (safeModel?.properties?[index].type == "chekbox")
                              ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListTile(
                                    leading: Checkbox(
                                      checkColor: Colors.white,
                                      value: safeModel
                                          ?.properties?[index].isSelected,
                                      onChanged: (bool? value) {},
                                    ),
                                    shape: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.5)),
                                    title: Text(
                                      safeModel?.properties?[index].title ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        safeModel?.properties?[index].hint ??
                                            ""),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListTile(
                                    leading: Icon(iconData[index], size: 35),
                                    shape: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.5)),
                                    title: Text(
                                      safeModel?.properties?[index].title ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: safeModel
                                              ?.properties?[index].hint),
                                    ),
                                  ),
                                )),
                  const SizedBox(height: 10),
                  ...?safeModel?.buttons?.map((e) => materialButton(context,
                      onPressed: () {},
                      title: e.title ?? "",
                      color: Color(int.parse("0xff${e.color ?? 'ffff'}"))))
                ],
              ),
            ),
          );
  }
}

materialButton(context,
    {required VoidCallback onPressed, required String title, Color? color}) {
  return SizedBox(
    height: 50,
    width: MediaQuery.of(context).size.width * .9,
    child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textColor: Colors.white,
        color: color ?? const Color.fromARGB(255, 0, 158, 61),
        onPressed: onPressed,
        child: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
  );
}

List<IconData> iconData = [
  Icons.person_rounded,
  Icons.category,
  Icons.directions_run_outlined,
  Icons.description,
  Icons.description,
  Icons.description
];
