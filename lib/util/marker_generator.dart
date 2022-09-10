import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter/scheduler.dart';

class MarkerGenerator {
   Function(Uint8List)? callback;
   Widget? markerWidgets;

  MarkerGenerator(this.markerWidgets, this.callback);

  void generate(BuildContext context) {
    if (SchedulerBinding.instance!.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance!.addPostFrameCallback((_) => afterFirstLayout(context));
    } else {
      afterFirstLayout(context);
    }
  }

  void afterFirstLayout(BuildContext context) {
    addOverlay(context);
  }

  void addOverlay(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);

    OverlayEntry entry = OverlayEntry(
        builder: (context) {
          return _MarkerHelper(
            markerWidgets: markerWidgets!,
            callback: callback!,
          );
        },
        maintainState: true);

    overlayState!.insert(entry);
  }
}

class _MarkerHelper extends StatefulWidget {
   Widget? markerWidgets;
   Function(Uint8List)? callback;

   _MarkerHelper({ this.markerWidgets, this.callback})
    ;

  @override
  _MarkerHelperState createState() => _MarkerHelperState();
}

class _MarkerHelperState extends State<_MarkerHelper> with AfterLayoutMixin {
  GlobalKey? globalKeys;

  @override
  void afterFirstLayout(BuildContext context) {
    _getBitmaps(context).then((list) {
      widget.callback!(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    final markerKey = GlobalKey();
    globalKeys = markerKey;
    return Transform.translate(
      offset: Offset(MediaQuery.of(context).size.width, 0),
      child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: RepaintBoundary(
                  key: markerKey,
                  child: widget.markerWidgets,
                ),
              ),

            ],
          )
      ),
    );
  }

  Future<Uint8List> _getBitmaps(BuildContext context) async {
    var futures = _getUint8List(globalKeys!);
    return futures;
  }

  Future<Uint8List> _getUint8List(GlobalKey markerKey) async {

    RenderRepaintBoundary boundary =
    markerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 0.55);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context);
}