import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/SuccessBanner.dart';
import '../components/FailureBanner.dart';
import '../main.dart';
import '../dio_interceptors.dart';

class CreateServiceScreenWidget extends StatefulWidget {
  const CreateServiceScreenWidget({Key key}) : super(key: key);

  @override
  _CreateServiceScreenWidgetState createState() =>
      _CreateServiceScreenWidgetState();
}

class _CreateServiceScreenWidgetState extends State<CreateServiceScreenWidget> {
  TextEditingController serviceNameController;
  TextEditingController setPriceController;
  TextEditingController setDurationController;
  TextEditingController shortBioController;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    serviceNameController = TextEditingController();
    setPriceController = TextEditingController();
    setDurationController = TextEditingController();
    shortBioController = TextEditingController();
  }

  bool loadingCreate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
        title: Text(
          'Create Service',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF57636C)),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              buttonSize: 48,
              icon: Icon(
                Icons.close_rounded,
                color: Color(0xFF57636C),
                size: 30,
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 300),
                    reverseDuration: Duration(milliseconds: 300),
                    child: HomePageWidget(),
                  ),
                );
              },
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: TextFormField(
                        controller: serviceNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Service Name',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF1F4F8),
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
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: TextFormField(
                        controller: setPriceController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Enter Price(AED)',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(20, 32, 20, 12),
                        ),
                        style: TextStyle(
                          color: Color(0xFF57636C),
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: TextFormField(
                        controller: setDurationController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Set Duration(hours)',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                          ),
                          hintText: 'ex: 30min = 0.5',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(20, 32, 20, 12),
                        ),
                        style: TextStyle(
                          color: Color(0xFF57636C),
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: TextFormField(
                        controller: shortBioController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Enter description here...',
                          hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF57636C),
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(20, 32, 20, 0),
                        ),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.start,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ],
                ),
                loadingCreate
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                        child: FFButtonWidget(
                          onPressed: () async {
                            createService();
                          },
                          text: 'Create Service',
                          options: FFButtonOptions(
                            width: 270,
                            height: 50,
                            color: Color(0xFF4B39EF),
                            textStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: 8,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createService() async {
    setState(() {
      loadingCreate = true;
    });
    final rs = (await api().post(
      "services/create",
      data: {
        'price': double.parse(setPriceController.text),
        'duration': setDurationController.text,
        'description': shortBioController.text,
        'name': serviceNameController.text,
      },
    ))
        .data;

    setState(() {
      loadingCreate = false;
    });

    await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300),
        child: HomePageWidget(),
      ),
    );
  }
}
