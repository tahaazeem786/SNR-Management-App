import 'dart:ffi';
import '../dio_interceptors.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snrmanagement/main.dart';

class ServicManagementScreenWidget extends StatefulWidget {
  const ServicManagementScreenWidget({Key key}) : super(key: key);

  @override
  _ServicManagementScreenWidgetState createState() =>
      _ServicManagementScreenWidgetState();
}

bool loadingDel = false;

class _ServicManagementScreenWidgetState
    extends State<ServicManagementScreenWidget> {
  TextEditingController changePriceController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    changePriceController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF4B39EF),
        automaticallyImplyLeading: false,
        title: Text(
          'Service Management',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Color(0xFFF1F4F8),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                child: TextFormField(
                  controller: changePriceController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Set New Price(AED)',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF57636C),
                      fontWeight: FontWeight.normal,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 32, 20, 12),
                  ),
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF57636C)),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                ),
              ),
              loading
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          updatePrice(double.parse(changePriceController.text));
                        },
                        text: 'Update Price',
                        options: FFButtonOptions(
                          width: 150,
                          height: 50,
                          color: Color(0xFF4B39EF),
                          textStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          elevation: 2,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: 40,
                        ),
                      ),
                    ),
              Spacer(),
              loadingDel
                  ? LinearProgressIndicator()
                  : Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      child: FFButtonWidget(
                        onPressed: () {
                          deleteService();
                        },
                        text: 'Delete Service',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          color: Color(0xFFE21B1B),
                          textStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          elevation: 2,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: 40,
                        ),
                      ),
                    ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 12),
                child: FFButtonWidget(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  text: 'Cancel',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50,
                    color: Color(0xFFF1F4F8),
                    textStyle: TextStyle(
                      fontFamily: 'Outfit',
                      color: Color(0xFF14181B),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF101213),
                      width: 1,
                    ),
                    borderRadius: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updatePrice(double price) async {
    setState(() {
      loading = true;
    });
    final rs = (await api().post(
      "services/updatePrice",
      data: {
        'id': currentServiceID,
        'price': price,
      },
    ))
        .data;

    setState(() {
      loading = false;
    });

    await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.leftToRight,
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300),
        child: HomePageWidget(),
      ),
    );
  }

  deleteService() async {
    setState(() {
      loadingDel = true;
    });

    final rs = (await api().post(
      "services/delete",
      data: {
        'id': currentServiceID,
      },
    ))
        .data;

    setState(() {
      loadingDel = false;
    });

    await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.leftToRight,
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300),
        child: HomePageWidget(),
      ),
    );
  }
}
