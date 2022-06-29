import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/create_service_screen_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../screens/servic_management_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dio_interceptors.dart';

var currentServiceID;

var list;
var listBookings;

var location1;
var location2;

bool loadedBookings;

void main() {
  runApp(MaterialApp(home: HomePageWidget()));
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  String dropDownValue1;
  String dropDownValue2;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = {
    'containerOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      duration: 350,
      initialState: AnimationState(
        offset: Offset(-40, 0),
        scale: 1,
        opacity: 0,
      ),
      finalState: AnimationState(
        offset: Offset(0, 0),
        scale: 1,
        opacity: 1,
      ),
    ),
  };

  @override
  void initState() {
    super.initState();
    getAllServices();
    getTodaysBookings();
    updateLocationData();
    setupTriggerAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onActionTrigger),
      this,
    );
  }

  bool locationDataLoading = false;

  updateLocationData() async {
    setState(() {
      locationDataLoading = true;
    });
    final rs = (await api()
            .get("location/allData", queryParameters: {'name': 'Shaheen'}))
        .data;
    location1 = rs['data'];

    final rs2 = (await api()
            .get("location/allData", queryParameters: {'name': 'Safran St'}))
        .data;
    location2 = rs2['data'];

    setState(() {
      location1 = location1;
      location2 = location2;
      locationDataLoading = false;
    });
  }

  updateOpenStatus(String name) async {
    try {
      final rs =
          (await api().post('location/openStatus', data: {'name': name})).data;
      print(rs.toString());
      updateLocationData();
    } catch (e) {
      print(e.toString() + 'HERES THE EXCEPTION');
    }
  }

  updateBarberNum(int numBarbers, String name) async {
    final rs = (await api().post('location/updatebarbernum',
            data: {'name': name, 'numBarbers': numBarbers}))
        .data;
  }

  bool loaded = false;
  bool noBookings = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF4B39EF),
        automaticallyImplyLeading: false,
        title: Text(
          'Scissors and Razors Employee',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 21,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Color(0xFF4B39EF),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Container(
                      width: double.infinity,
                      height: 270,
                      decoration: BoxDecoration(
                        color: Color(0xFF4B39EF),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                            child: Text(
                              'Service Management',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 0, 0, 12),
                            child: Text(
                              'Edit, Change, or Add services below',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Expanded(
                              child: !loaded
                                  ? servicesRecordLoading()
                                  : servicesRecord()),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 7,
                                color: Color(0x2F1D2429),
                                offset: Offset(0, 3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12, 12, 12, 12),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 0, 12),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Upcoming Bookings',
                                                  style: TextStyle(
                                                    fontFamily: 'Outfit',
                                                    color: Color(0xFF101213),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(),
                                              height: 250,
                                              child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 12, 0),
                                                  child: !loadedBookings
                                                      ? noBookingsWidget()
                                                      : noBookings
                                                          ? noBookingsWidget()
                                                          : todaysBookings()))
                                        ]))
                                  ])))),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7,
                            color: Color(0x2F1D2429),
                            offset: Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                        child: locationDataLoading
                            ? Container()
                            : Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.local_police_rounded,
                                    color: Color(0xFF4B39EF),
                                    size: 32,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 0, 8, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Shaheen',
                                            style: TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Color(0xFF262D34),
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 4, 0, 0),
                                            child: Text(
                                              'Status: ' +
                                                  (location1['open']
                                                      ? " Open"
                                                      : " Closed"),
                                              style: TextStyle(
                                                fontFamily: 'Lexend Deca',
                                                color: Color(0xFF57636C),
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  FlutterFlowDropDown(
                                    options: [
                                      '1',
                                      '2',
                                      '3',
                                      '4',
                                      '5',
                                      '6',
                                      '7',
                                      '8',
                                      '9',
                                      '10'
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        dropDownValue1 = val;
                                      });

                                      updateBarberNum(int.parse(val),
                                          location1['locationName']);
                                    },
                                    width: 90,
                                    height: 25,
                                    textStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                    hintText: 'Barbers',
                                    fillColor: Colors.white,
                                    elevation: 2,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0,
                                    borderRadius: 0,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        12, 4, 12, 4),
                                    hidesUnderline: true,
                                  ),
                                  FFButtonWidget(
                                    onPressed: () {
                                      updateOpenStatus(
                                          location1['locationName']);
                                    },
                                    text:
                                        (location1['open'] ? 'Close' : 'Open'),
                                    options: FFButtonOptions(
                                      width: 75,
                                      height: 25,
                                      color: !location1['open']
                                          ? Color(0xFF39D2C0)
                                          : Color(0xFFFF5963),
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
                                ],
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7,
                            color: Color(0x2F1D2429),
                            offset: Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                        child: locationDataLoading
                            ? Container()
                            : Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.local_police_rounded,
                                    color: Color(0xFF4B39EF),
                                    size: 32,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 0, 8, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            location2['locationName'],
                                            style: TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Color(0xFF262D34),
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 4, 0, 0),
                                            child: Text(
                                              'Status: ' +
                                                  (location2['open']
                                                      ? 'Open'
                                                      : 'Closed'),
                                              style: TextStyle(
                                                fontFamily: 'Lexend Deca',
                                                color: Color(0xFF57636C),
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  FlutterFlowDropDown(
                                    options: [
                                      '1',
                                      '2',
                                      '3',
                                      '4',
                                      '5',
                                      '6',
                                      '7',
                                      '8',
                                      '9',
                                      '10'
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        dropDownValue2 = val;
                                      });

                                      updateBarberNum(int.parse(val),
                                          location2['locationName']);
                                    },
                                    width: 90,
                                    height: 25,
                                    textStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                    hintText: 'Barbers',
                                    fillColor: Colors.white,
                                    elevation: 2,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0,
                                    borderRadius: 0,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        12, 4, 12, 4),
                                    hidesUnderline: true,
                                  ),
                                  FFButtonWidget(
                                    onPressed: () {
                                      updateOpenStatus(
                                          location2['locationName']);
                                    },
                                    text: !location2['open'] ? 'Open' : 'Close',
                                    options: FFButtonOptions(
                                      width: 75,
                                      height: 25,
                                      color: !location2['open']
                                          ? Color(0xFF39D2C0)
                                          : Color(0xFFFF5963),
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
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget todaysBookings() {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        for (var i in listBookings)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFFF1F4F8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              i['service'].toString() +
                                  ' at ' +
                                  DateFormat('HH:mm')
                                      .format(DateTime.parse(i['start_time']))
                                      .toString(),
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Color(0xFF101213),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                              child: Text(
                                'For: ' +
                                    i['name']
                                        .substring(0, i['name'].indexOf(' ')) +
                                    ' at ' +
                                    i['location'].toString(),
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF57636C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                              child: Text(
                                'Contact: ' + i['phone_number'],
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF57636C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Color(0xFF57636C),
                        size: 24,
                      ),
                      onPressed: () => cancelBooking(i['id']),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  cancelBooking(int id) async {
    setState(() {
      loadedBookings = false;
    });

    final rs = (await api().post("bookings/cancel", data: {
      'id': id,
    }))
        .data;

    getTodaysBookings();
  }

  Widget noBookingsWidget() {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cut,
            color: Color(0xFF7C8791),
            size: 90,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Seems you don’t have any bookings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: Color(0xFF090F13),
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'When users make bookings for today, they\'ll show up here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Color(0xFF7C8791),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getAllServices() async {
    setState(() {
      loaded = false;
    });
    try {
      print("TEST");
      final rs = (await api().get("services/getAll")).data;
      list = rs['data'];

      if (list == null) {
        setState(() {});
      }
    } catch (e) {
      setState(() {});
    } finally {
      setState(() {
        loaded = true;
      });
    }
  }

  getTodaysBookings() async {
    setState(() {
      loadedBookings = false;
    });

    try {
      print("IN THE TRY");
      final rs = (await api().get("bookings/allRemainingToday")).data;
      final validMap = json.decode(json.encode(rs)) as Map<String, dynamic>;
      listBookings = validMap['bookings'];
      if (!(listBookings is List<dynamic>))
        listBookings = listBookings.values.toList();
      print(listBookings.toString());

      if (listBookings == null)
        setState(() {
          noBookings = true;
          print("ITS NULL");
        });
      else
        setState(() {
          loadedBookings = true;
          noBookings = false;
          print("MADE IT TO TRUE");
        });
    } catch (e) {
      setState(() {
        noBookings = true;
        print(e.toString() + " MADE AN EXCEPTION BRUH");
      });
    }

    setState(() {
      loadedBookings = true;
    });
  }

  Widget servicesRecordLoading() {
    return ListView(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 12),
            child: Container(
              width: 270,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x2B202529),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 12),
            child: Container(
              width: 270,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x2B202529),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(),
                  ],
                ),
              ),
            ),
          ),
        ]);
  }

  Widget servicesRecord() {
    return ListView(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        for (var i in list)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 12),
            child: Container(
              width: 270,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x2B202529),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            i['name'],
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF14181B),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.price_check_outlined,
                          color: Color(0xFF4B39EF),
                          size: 24,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                          child: Text(
                            i['price'].toString() + " AED",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF14181B),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            i['price'],
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF14181B),
                              fontSize: 34,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ' AED',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Color(0xFF57636C),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          FlutterFlowIconButton(
                            borderColor: Color(0xFFF1F4F8),
                            borderRadius: 30,
                            borderWidth: 2,
                            buttonSize: 44,
                            icon: Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF57636C),
                              size: 24,
                            ),
                            onPressed: () async {
                              currentServiceID = i['id'];
                              await Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 300),
                                  reverseDuration: Duration(milliseconds: 300),
                                  child: ServicManagementScreenWidget(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.local_fire_department_sharp,
                          color: Color(0xFFFFA130),
                          size: 24,
                        ),
                        Text(
                          i['duration'] + " hours",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0xFF14181B),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.add,
            color: Color(0xFF101213),
            size: 30,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                duration: Duration(milliseconds: 300),
                reverseDuration: Duration(milliseconds: 300),
                child: CreateServiceScreenWidget(),
              ),
            );
          },
        ),
      ],
    );
  }
}
