import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/Model/StockItemModel.dart';
import 'package:searchfield/searchfield.dart';

import '../utilits/Common_Colors.dart';
import '../utilits/Text_Style.dart';

//TEXTFORM FIELD

Widget textFormField(
    {TextEditingController? Controller,
    String? Function(String?)? validating,
    bool? isEnabled,
    void Function(String)? onChanged,
    required String hintText,
    List<TextInputFormatter>? inputFormatters,
    required TextInputType keyboardtype}) {
  return Container(
    // height: 50,
    child: TextFormField(
      enabled: isEnabled,
      controller: Controller,
      textCapitalization: TextCapitalization.none,
      inputFormatters: inputFormatters,
      validator: validating,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintText: hintText,
        hintStyle: phoneHT,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
      style: Textfield_Style,
      keyboardType: keyboardtype,
    ),
  );
}

//white
Widget textFormField2(
    {TextEditingController? Controller,
    String? Function(String?)? validating,
    bool? isEnabled,
    void Function(String)? onChanged,
    required String hintText,
    List<TextInputFormatter>? inputFormatters,
    required TextInputType keyboardtype}) {
  return Container(
    // height: 50,
    child: TextFormField(
      enabled: isEnabled,
      controller: Controller,
      textCapitalization: TextCapitalization.none,
      inputFormatters: inputFormatters,
      validator: validating,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: white1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: white1),
        ),
        fillColor: white1,
        filled: true,
      ),
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
      style: Textfield_Style,
      keyboardType: keyboardtype,
    ),
  );
}

//TEXTFIELD DATE PICKER
Widget TextFieldDatePicker(
    {TextEditingController? Controller,
    String? Function(String?)? validating,
    void Function(String)? onChanged,
    required String hintText,
    void Function()? onTap}) {
  return TextFormField(
    controller: Controller,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onTap: onTap,
    readOnly: true,
    keyboardType: TextInputType.number,
    maxLength: 15,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: white1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: white1),
      ),
      counterText: "",
      hintText: 'DD / MM / YYYY',
      helperStyle: phoneHT,
      prefixIcon: Icon(
        Icons.calendar_month,
        color: grey1,
        size: 24,
      ),
      hintStyle: const TextStyle(
        fontFamily: "Inter",
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
        color: Colors.grey,
      ),
      errorMaxLines: 1,
      contentPadding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      fillColor: white1,
      filled: true,
    ),
    validator: validating,
    onChanged: onChanged,
    textInputAction: TextInputAction.next,
    style: const TextStyle(
      fontFamily: "Inter",
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
      color: Colors.black,
    ),
  );
}

// TEXT FIELD PASSWORD
Widget textFieldPassword(
    {TextEditingController? Controller,
    String? Function(String?)? validating,
    void Function(String)? onChanged,
    required bool obscure,
    required void Function()? onPressed,
    required String hintText,
    required TextInputType keyboardtype}) {
  return Container(
    // height: 50,
    child: TextFormField(
      controller: Controller,
      obscureText: obscure,
      validator: validating,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintText: hintText,
        hintStyle: phoneHT,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: white2),
            borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.lock : Icons.lock_open,
            color: white1,
          ),
          onPressed: onPressed,
        ),
        fillColor: white1,
        filled: true,
      ),
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardtype,
      style: Textfield_Style,
    ),
  );
}

//DESCRIPTION
Widget textfieldDescription(
    {TextEditingController? Controller,
    String? Function(String?)? validating,
    required String hintText,
    required bool readOnly}) {
  return Container(
    // height: 50,
    child: TextFormField(
      readOnly: readOnly,
      controller: Controller,
      textCapitalization: TextCapitalization.none,
      maxLines: 5,
      minLines: 3,
      keyboardType: TextInputType.multiline,
      validator: validating,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintText: hintText,
        hintStyle: phoneHT,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: white1),
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: white1,
        filled: true,
      ),
      textInputAction: TextInputAction.newline,
      style: Textfield_Style,
    ),
  );
}

//SEARCH BAR
Widget textFormFieldSearchBar({
  TextEditingController? Controller,
  String? Function(String?)? validating,
  bool? isEnabled,
  void Function(String)? onChanged,
  required String hintText,
  List<TextInputFormatter>? inputFormatters,
  required TextInputType keyboardtype,
  required void Function()? onTap,
}) {
  return Container(
    // height: 50,
    child: TextFormField(
      onTap: onTap,
      enabled: isEnabled,
      controller: Controller,
      textCapitalization: TextCapitalization.none,
      inputFormatters: inputFormatters,
      validator: validating,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintText: hintText,
        hintStyle: phoneHT,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: white1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: white1),
        ),
        fillColor: white1,
        filled: true,
        prefixIcon: Icon(
          Icons.search,
          size: 24,
          color: grey2,
        ),
      ),
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
      style: Textfield_Style,
      keyboardType: keyboardtype,
    ),
  );
}

Widget buildCompanyInfoRow(String pathPNG, String companyName,
    TextStyle textStyle, double imageWidth, double imageHeight) {
  return Container(
    child: Row(
      children: [
        Container(
          height: imageHeight,
          width: imageWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                  image: AssetImage("lib/assets/$pathPNG"), fit: BoxFit.cover)),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            child: Text(
              companyName,
              style: textStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget collegeRowTitle(String pathPNG, String companyName, TextStyle textStyle,
    double imageWidth, double imageHeight) {
  return Container(
    child: Row(
      children: [
        Container(
          height: imageHeight,
          width: imageWidth,
          child: Image(
            image: AssetImage("lib/assets/$pathPNG"),
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            child: Text(
              companyName,
              style: textStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}

//DropDownExperience
Widget dropDownField(
  context, {
  required String? value,
  required List<String>? listValue,
  required void Function(String?)? onChanged,
  required String hintT,
}) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintStyle: phoneHT,
        hintText: hintT,
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: Colors.black,
          size: 35,
        ),
      ),
      items: listValue?.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(option),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

Widget dropDownField1(
  context, {
  required String? value,
  required List<Clients>? listValue,
  required void Function(String?)? onChanged,
  required String hintT,
}) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintStyle: phoneHT,
        hintText: hintT,
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: Colors.black,
          size: 35,
        ),
      ),
      items: listValue?.map((Clients option) {
        return DropdownMenuItem<String>(
          value: option.cusFirstName,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(option.cusFirstName ?? ""),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

Widget dropDownField2(
  context, {
  required String? value,
  required List<Companies>? listValue,
  required void Function(String?)? onChanged,
  required String hintT,
}) {
  return Container(
    height: 70,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
    ),
    child: Stack(
      children: [
        // Positioned(
        //   left: 10,
        //   top: 15,
        //   child: Align(
        //     alignment: Alignment.center,
        //     child: Text(
        //       hintT,
        //       style: phoneHT,
        //       textAlign: TextAlign.start,
        //     ),
        //   ),
        // ),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hintT,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey),
            ),
            fillColor: Colors.transparent,
            filled: true,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_sharp,
            color: Colors.black,
            size: 35,
          ),
          items: listValue?.map((Companies option) {
            return DropdownMenuItem<String>(
              value: option.companyBranch,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(option.companyBranch ?? ""),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

Widget dropDownField3(
  context, {
  required String? value,
  required List<Executives>? listValue,
  required void Function(String?)? onChanged,
  required String hintT,
}) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintStyle: phoneHT,
        hintText: hintT,
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: Colors.black,
          size: 35,
        ),
      ),
      items: listValue?.map((Executives option) {
        return DropdownMenuItem<String>(
          value: option.name,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(option.name ?? ""),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

Widget dropDownField4(
  context, {
  required String? value,
  required List<Company>? listValue,
  required void Function(String?)? onChanged,
  required String hintT,
}) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintStyle: phoneHT,
        hintText: hintT,
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: Colors.black,
          size: 35,
        ),
      ),
      items: listValue?.map((Company option) {
        return DropdownMenuItem<String>(
          value: option.name,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(option.name ?? ""),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

Widget dropDownField5(
  context, {
  required String? value,
  required List<ClientDetails>? listValue,
  required void Function(String?)? onChanged,
  required String hintT,
}) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintStyle: phoneHT,
        hintText: hintT,
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: Colors.black,
          size: 35,
        ),
      ),
      items: listValue?.map((ClientDetails option) {
        return DropdownMenuItem<String>(
          value: option.cusFirstName,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(option.cusFirstName ?? ""),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

Widget dropDownField6(
  context, {
  required String? value,
  required List<Branch>? listValue,
  required void Function(String?)? onChanged,
  required String hintT,
}) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintStyle: phoneHT,
        hintText: hintT,
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: Colors.black,
          size: 35,
        ),
      ),
      items: listValue?.map((Branch option) {
        return DropdownMenuItem<String>(
          value: option.branchName,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(option.branchName ?? ""),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

Widget dropDownField7(
  context, {
  required String? value,
  required List<StockItemData>? listValue,
  required void Function(String?)? onChanged,
  required String hintT,
}) {
  return Center(
    child: Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
      child: Center(
        child: DropdownButtonFormField<String>(
          // padding: EdgeInsets.only(left: 30),
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hintT,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey),
            ),
            fillColor: Colors.transparent,
            filled: true,
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.black,
              size: 35,
            ),
          ),
          items: listValue?.map((StockItemData option) {
            return DropdownMenuItem<String>(
              value: option.itemName,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Text(option.itemName ?? ""),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ),
  );
}

Widget dropDownSearchField(
  context, {
  required FocusNode? focus,
  required List<StockItemData> listValue,
  required String? Function(String?)? validator,
  required void Function(SearchFieldListItem<StockItemData> x)? onChanged,
  required String hintText,
  required String initValue,
}) {
  return Container(
    // height: 50,
    padding: const EdgeInsets.symmetric(horizontal: 20.0),

    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.white),
    child: SearchField(
      initialValue: initValue == ""
          ? null
          : SearchFieldListItem<StockItemData>(initValue),
      focusNode: focus,
      suggestionDirection: SuggestionDirection.down,
      suggestions: listValue
          .map((e) => SearchFieldListItem<StockItemData>(e.itemName ?? ""))
          .toList(),
      suggestionState: Suggestion.expand,
      textInputAction: TextInputAction.next,
      searchStyle: TextStyle(
        fontSize: 18,
        color: Colors.black.withOpacity(0.8),
      ),
      validator: validator,
      searchInputDecoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey),
        ),
        fillColor: Colors.transparent,
        filled: true,
      ),
      // searchInputDecoration: InputDecoration(
      //   contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      //   hintText: hintText,
      //   hintStyle: phoneHT,
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(10),
      //     borderSide: BorderSide(color: white2),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(10),
      //     borderSide: BorderSide(color: white2),
      //   ),
      //   fillColor: white2,
      //   filled: true,
      // ),
      maxSuggestionsInViewPort: 5,
      itemHeight: 40,
      onSuggestionTap: onChanged,
    ),
  );
}

Widget dropDownClientSearchField(
  context, {
  required FocusNode? focus,
  required List<Clients> listValue,
  required String? Function(String?)? validator,
  required void Function(SearchFieldListItem<Clients> x)? onChanged,
  required String hintText,
  required String initValue,
}) {
  return Container(
    height: 60,
    // padding: const EdgeInsets.symmetric(horizontal: 10.0),

    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.white),
    child: SearchField(
      initialValue:
          initValue == "" ? null : SearchFieldListItem<Clients>(initValue),
      focusNode: focus,
      suggestionDirection: SuggestionDirection.down,
      suggestions: listValue
          .map((e) => SearchFieldListItem<Clients>(e.cusFirstName ?? ""))
          .toList(),
      suggestionState: Suggestion.expand,
      textInputAction: TextInputAction.next,
      searchStyle: TextStyle(
        fontSize: 16,
        color: Colors.black.withOpacity(0.8),
      ),
      validator: validator,
      searchInputDecoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey),
        ),
        fillColor: Colors.transparent,
        filled: true,
      ),
      // searchInputDecoration: InputDecoration(
      //   contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      //   hintText: hintText,
      //   hintStyle: phoneHT,
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(10),
      //     borderSide: BorderSide(color: white2),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(10),
      //     borderSide: BorderSide(color: white2),
      //   ),
      //   fillColor: white2,
      //   filled: true,
      // ),
      maxSuggestionsInViewPort: 5,
      itemHeight: 40,
      onSuggestionTap: onChanged,
    ),
  );
}

Widget dropDownClientGSTSearchField(
  context, {
  required FocusNode? focus,
  required List<Clients> listValue,
  required String? Function(String?)? validator,
  required void Function(SearchFieldListItem<Clients> x)? onChanged,
  required String hintText,
  required String initValue,
}) {
  return Container(
    height: 60,
    // padding: const EdgeInsets.symmetric(horizontal: 10.0),

    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.white),
    child: SearchField(
      initialValue:
          initValue == "" ? null : SearchFieldListItem<Clients>(initValue),
      focusNode: focus,
      suggestionDirection: SuggestionDirection.down,
      suggestions: listValue
          .map((e) => SearchFieldListItem<Clients>(e.gstNo ?? ""))
          .toList(),
      suggestionState: Suggestion.expand,
      textInputAction: TextInputAction.next,
      searchStyle: TextStyle(
        fontSize: 16,
        color: Colors.black.withOpacity(0.8),
      ),
      validator: validator,
      searchInputDecoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey),
        ),
        fillColor: Colors.transparent,
        filled: true,
      ),
      // searchInputDecoration: InputDecoration(
      //   contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      //   hintText: hintText,
      //   hintStyle: phoneHT,
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(10),
      //     borderSide: BorderSide(color: white2),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(10),
      //     borderSide: BorderSide(color: white2),
      //   ),
      //   fillColor: white2,
      //   filled: true,
      // ),
      maxSuggestionsInViewPort: 5,
      itemHeight: 40,
      onSuggestionTap: onChanged,
    ),
  );
}

class MultiSelectDropdown extends StatefulWidget {
  final List<Executives> items;
  final List<Executives> selectedItems;
  final ValueChanged<List<Executives>> onChanged;

  MultiSelectDropdown({
    required this.items,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  late List<bool> _isCheckedList;

  @override
  void initState() {
    super.initState();
    _isCheckedList = List<bool>.filled(widget.items.length, false);
    for (int i = 0; i < widget.selectedItems.length; i++) {
      int index = widget.items.indexOf(widget.selectedItems[i]);
      if (index != -1) {
        _isCheckedList[index] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        InputDecorator(
          decoration: InputDecoration(
            labelText: 'Select Executive',
            border: OutlineInputBorder(),
          ),
          child: SizedBox(
            height: 200, // Adjust the height as needed
            child: SingleChildScrollView(
              child: Column(
                children: List<Widget>.generate(
                  widget.items.length,
                  (int index) {
                    return CheckboxListTile(
                      title: Text(widget.items[index].name ?? ""),
                      value: _isCheckedList[index],
                      onChanged: (bool? value) {
                        setState(() {
                          _isCheckedList[index] = value ?? false;

                          List<Executives> selectedItems = [];
                          for (int i = 0; i < widget.items.length; i++) {
                            if (_isCheckedList[i]) {
                              selectedItems.add(widget.items[i]);
                            }
                          }
                          widget.onChanged(selectedItems);
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
