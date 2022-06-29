import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FailureBannerWidget extends StatefulWidget {
  const FailureBannerWidget({Key key}) : super(key: key);

  @override
  _FailureBannerWidgetState createState() => _FailureBannerWidgetState();
}

class _FailureBannerWidgetState extends State<FailureBannerWidget>
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
            color: Color(0xFF9B0B0B),
          ),
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Text(
              'Failure, Try Again',
              style:TextStyle(
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
