import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessBannerWidget extends StatefulWidget {
  const SuccessBannerWidget({Key key}) : super(key: key);

  @override
  _SuccessBannerWidgetState createState() => _SuccessBannerWidgetState();
}

class _SuccessBannerWidgetState extends State<SuccessBannerWidget>
    with TickerProviderStateMixin {
  final animationsMap = {
    'containerOnActionTriggerAnimation': AnimationInfo(
      curve: Curves.linear,
      trigger: AnimationTrigger.onActionTrigger,
      duration: 920,
      fadeIn: true,
      initialState: AnimationState(
        offset: Offset(0, 0),
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
    setupTriggerAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onActionTrigger),
      this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.rectangle,
          ),
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Text(
              'Success!',
              style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
            ),
          ),
        ).animated([animationsMap['containerOnActionTriggerAnimation']]),
      ),
    );
  }
}
