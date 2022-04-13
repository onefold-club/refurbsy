import 'package:flutter/material.dart';

class AddInvInfo extends StatefulWidget {
  const AddInvInfo({ Key? key }) : super(key: key);

  @override
  _AddInvInfoState createState() => _AddInvInfoState();
}

class _AddInvInfoState extends State<AddInvInfo> {

  String brand = '';
  String type = '';
  String dimension = '';
  String color = '';
  String condition = '';
  final TextEditingController colorcontroller = TextEditingController();
  final TextEditingController conditioncontroller = TextEditingController();
  final List<String> coloroptions = ['Red', 'White', 'Green', 'Black'];
  final List<String> conditionoptions = ['New', 'Used'];

  @override
  Widget build(BuildContext context) {

    var _scrH = MediaQuery.of(context).size.height;
    var _scrW = MediaQuery.of(context).size.width;
    var _padV = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;
    var _padH = MediaQuery.of(context).padding.left + MediaQuery.of(context).padding.right;

    var scrH = _scrH - _padV - kToolbarHeight;
    var scrW = _scrW - _padH;

    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: scrW * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white
                ),
                padding: EdgeInsets.symmetric(vertical: scrH * 0.05, horizontal: _scrW * 0.06),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Text('Brand', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black38),),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: scrH * 0.02),
                      child: TextFormField(
                        style: const TextStyle(fontSize: 18.0),
                        decoration: const InputDecoration(
                          hintText: 'Text',
                          hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey,),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0),),
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.all(Radius.circular(10.0),),
                          //   borderSide: BorderSide(color: Colors.white, width: 3.0),
                          // ),
                        ),
                        keyboardType: TextInputType.text,
                        // validator: (val) => val!.isEmpty ? 'Please enter password' : null,
                        onChanged: (val) {
                          setState(() => brand = val);
                        }
                      ),
                    ),
                    Row(
                      children: const [
                        Text('Type', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black38),),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: scrH * 0.02),
                      child: TextFormField(
                        style: const TextStyle(fontSize: 18.0),
                        decoration: const InputDecoration(
                          hintText: 'Text',
                          hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey,),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0),),
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.all(Radius.circular(10.0),),
                          //   borderSide: BorderSide(color: Colors.white, width: 3.0),
                          // ),
                        ),
                        keyboardType: TextInputType.text,
                        // validator: (val) => val!.isEmpty ? 'Please enter password' : null,
                        onChanged: (val) {
                          setState(() => type = val);
                        }
                      ),
                    ),
                    Row(
                      children: const [
                        Text('Dimensions', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black38),),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: scrH * 0.02),
                      child: TextFormField(
                        style: const TextStyle(fontSize: 18.0),
                        decoration: const InputDecoration(
                          hintText: '25in / 105in / 25in',
                          hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey,),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0),),
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.all(Radius.circular(10.0),),
                          //   borderSide: BorderSide(color: Colors.white, width: 3.0),
                          // ),
                        ),
                        keyboardType: TextInputType.text,
                        // validator: (val) => val!.isEmpty ? 'Please enter password' : null,
                        onChanged: (val) {
                          setState(() => dimension = val);
                        }
                      ),
                    ),
                    Row(
                      children: const [
                        Text('Color', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black38),),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: scrH * 0.02),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          border:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: DropdownButtonHideUnderline(child: Container()),
                          hint: const Text('Select color'),
                          value: color == '' ? null : color,
                          onChanged: (newValue) {
                            setState(() {
                              colorcontroller.value = TextEditingValue(text: newValue.toString());
                              color = newValue.toString();
                            });
                          },
                          items: coloroptions.map((option) {
                            return DropdownMenuItem(
                              child: Text(option),
                              value: option,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Row(
                      children: const [
                        Text('Condition', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black38),),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: scrH * 0.02),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          border:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: DropdownButtonHideUnderline(child: Container()),
                          hint: const Text('Select condition'),
                          value: condition == '' ? null : condition,
                          onChanged: (newValue) {
                            setState(() {
                              conditioncontroller.value = TextEditingValue(text: newValue.toString());
                              condition = newValue.toString();
                            });
                          },
                          items: conditionoptions.map((option) {
                            return DropdownMenuItem(
                              child: Text(option),
                              value: option,
                            );
                          }).toList(),
                        ),
                      ),
                    ),                  
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: SizedBox(
                  width: scrW * 0.85,
                  // height: scrH * 0.05,
                  child: ElevatedButton(
                    child: const Text('Done', style: TextStyle(color: Colors.white, fontSize: 18.0),),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context, [brand, type, dimension, color, condition]);
                    }
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}