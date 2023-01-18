import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/select_value_boc/check_box_bloc.dart';
import '../controller/select_value_boc/drop_down_bloc.dart';
import '../controller/validation_bloc/validation_bloc.dart';
import '../model/data_model.dart';
import '../resources/resources.dart';

class SafeScreen extends StatefulWidget {
  const SafeScreen({Key? key}) : super(key: key);

  @override
  State<SafeScreen> createState() => _SafeScreenState();
}

class _SafeScreenState extends State<SafeScreen> {
  SafeModel? safeModel;
  final _formKey = GlobalKey<FormState>();

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

  Form formView() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: safeModel?.properties?.length,
              itemBuilder: (context, index) =>
                  (safeModel?.properties?[index].type ==
                          TypePropertiesData().optionTypeProperties)
                      ? MultiBlocProvider(
                          providers: [
                            BlocProvider<ValidationBloc>(
                              create: (context) => ValidationBloc(),
                            ),
                            BlocProvider<DropDownBloc>(
                              create: (context) => DropDownBloc(),
                            ),
                          ],
                          child: dropDownBlocBuilder(
                              index: index,
                              properties: safeModel?.properties?[index]),
                        )
                      : (safeModel?.properties?[index].type ==
                              TypePropertiesData().checkBoxTypeProperties)
                          ? BlocProvider<CheckBoxBloc>(
                              create: (context) => CheckBoxBloc(),
                              child: checkBoxView(
                                  properties: safeModel?.properties?[index]),
                            )
                          : BlocProvider<ValidationBloc>(
                              create: (context) => ValidationBloc(),
                              child: textFieldBlocBuilder(
                                  index: index,
                                  properties: safeModel?.properties?[index]),
                            ),
            ),
            const SizedBox(height: 10),
            ...?safeModel?.buttons?.map((e) => materialButton(context,
                    onPressed: () {
                  final isValid = _formKey.currentState?.validate();
                  if (isValid != false) {
                    print("submit");
                    print(safeModel?.properties?[0].selectedOption);
                    print(safeModel?.properties?[1].selectedOption);
                    print(safeModel?.properties?[2].selectedOption);
                    print(safeModel?.properties?[3].selectedOption);
                    print(safeModel?.properties?[4].selectedOption);
                    print(safeModel?.properties?[5].selectedOption);
                  }
                },
                    title: e.title ?? "",
                    color: Color(int.parse("0xff${e.color ?? 'ffff'}"))))
          ]),
        ),
      ),
    );
  }

  textFieldBlocBuilder({Properties? properties, required int index}) {
    return BlocBuilder<ValidationBloc, ValidationState>(
      builder: (context, state) {
        if (state is ValidationError) {
          return TextFieldView(
              properties: properties,
              index: index,
              isError: true,
              validator: (value) {
                if (value == '' && properties?.isRequired == "true") {
                  BlocProvider.of<ValidationBloc>(context)
                      .add(ValidationInComplete());
                  return "";
                } else {
                  return null;
                }
              });
        } else {
          return TextFieldView(
            properties: properties,
            index: index,
            validator: (value) {
              if (value == '' && properties?.isRequired == "true") {
                BlocProvider.of<ValidationBloc>(context)
                    .add(ValidationInComplete());
                return "";
              } else {
                return null;
              }
            },
            isError: false,
          );
        }
      },
    );
  }

  Padding checkBoxView({Properties? properties}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ListTile(
        leading: BlocBuilder<CheckBoxBloc, CheckBoxState>(
          builder: (context, state) {
            return Checkbox(
              activeColor:
                  Color(int.parse("0xff${safeModel?.color ?? 'ffff'}")),
              checkColor: ColorResources().checkBoxUncheckBGColor,
              value: properties?.selectedOption == "true" ? true : false,
              onChanged: (bool? value) {
                properties?.selectedOption = value.toString();
                BlocProvider.of<CheckBoxBloc>(context)
                    .add(SelectValueForCheckBox());
              },
            );
          },
        ),
        shape: listTileUnderlineWidget(),
        title: Text(
          properties?.title ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(properties?.hint ?? ""),
      ),
    );
  }

  BlocBuilder dropDownBlocBuilder(
      {Properties? properties, required int index}) {
    return BlocBuilder<ValidationBloc, ValidationState>(
      builder: (context, state) {
        if (state is ValidationError) {
          return DropDownView(
              isError: true,
              index: index,
              properties: properties,
              validator: (value) {
                if (value == null && properties?.isRequired == "true") {
                  BlocProvider.of<ValidationBloc>(context)
                      .add(ValidationInComplete());
                  return '';
                } else {
                  return null;
                }
              });
        } else {
          return DropDownView(
              isError: false,
              index: index,
              properties: properties,
              validator: (value) {
                if (value == null && properties?.isRequired == "true") {
                  BlocProvider.of<ValidationBloc>(context)
                      .add(ValidationInComplete());
                  return "";
                } else {
                  return null;
                }
              });
        }
      },
    );
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
            body: formView());
  }
}

materialButton(context,
    {required VoidCallback onPressed, required String title, Color? color}) {
  return SizedBox(
    height: 50,
    width: MediaQuery.of(context).size.width,
    child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textColor: Colors.white,
        color: color ?? const Color.fromARGB(255, 0, 158, 61),
        onPressed: onPressed,
        child: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
  );
}

class DropDownView extends StatefulWidget {
  const DropDownView(
      {Key? key,
      this.properties,
      required this.index,
      required this.validator,
      required this.isError})
      : super(key: key);

  final Properties? properties;
  final int index;
  final bool isError;
  final FormFieldValidator validator;

  @override
  State<DropDownView> createState() => _DropDownViewState();
}

class _DropDownViewState extends State<DropDownView> {
  UnderlineInputBorder dropDownBorder() {
    return const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white));
  }

  dropDownMenu() {
    return DropdownButtonFormField(
        decoration: InputDecoration(
            errorStyle: const TextStyle(fontSize: 0.1),
            focusedErrorBorder: dropDownBorder(),
            errorBorder: dropDownBorder(),
            focusedBorder: dropDownBorder(),
            enabledBorder: dropDownBorder()),
        value: widget.properties?.selectedOption,
        validator: widget.validator,
        hint: Text(widget.properties?.hint ?? "",
            style: TextStyle(
                color: (widget.isError)
                    ? ColorResources().requiredFieldErrorColor
                    : null,
                fontWeight: (widget.isError) ? FontWeight.bold : null)),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: widget.properties?.options?.map((items) {
          return DropdownMenuItem(
            value: items.title,
            child: Text(items.title.toString(), overflow: TextOverflow.clip),
          );
        }).toList(),
        onChanged: (newValue) {
          widget.properties?.selectedOption = newValue;
          BlocProvider.of<DropDownBloc>(context).add(SelectValue());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        leading: Icon(iconData[widget.index], size: 35),
        shape: listTileUnderlineWidget(),
        title: Text(
          widget.properties?.title ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: SizedBox(
          child: BlocBuilder<DropDownBloc, DropDownState>(
            builder: (context, state) {
              return dropDownMenu();
            },
          ),
        ),
      ),
    );
  }
}

class TextFieldView extends StatelessWidget {
  const TextFieldView(
      {Key? key,
      this.properties,
      required this.isError,
      required this.validator,
      required this.index})
      : super(key: key);

  final Properties? properties;
  final int index;
  final bool isError;
  final FormFieldValidator validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ListTile(
        leading: Icon(iconData[index], size: 35),
        shape: listTileUnderlineWidget(),
        title: Text(
          properties?.title ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: TextFormField(
          validator: validator,
          onChanged: (value) => properties?.selectedOption = value,
          decoration: InputDecoration(
              errorStyle: const TextStyle(fontSize: 0.1),
              border: InputBorder.none,
              hintStyle: TextStyle(
                  color: (isError)
                      ? ColorResources().requiredFieldErrorColor
                      : null,
                  fontWeight: (isError) ? FontWeight.bold : null),
              hintText: properties?.hint),
        ),
      ),
    );
  }
}

UnderlineInputBorder listTileUnderlineWidget() {
  return UnderlineInputBorder(
      borderSide: BorderSide(
          color: ColorResources().listTileUnderlineColor, width: 0.5));
}
