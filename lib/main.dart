import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasPermissions = false;
  CompassEvent? _lastRead;
  DateTime? _lastReadAt;

  @override
  void initState() {
    super.initState();

    _fetchPermissionStatus();
  }

  @override

  Color backColl(double? direction){
    var coll;
    if(direction != null){
      if(direction <= 22.5 && direction >= -22.5) {
        coll = Colors.yellowAccent;
      } else if(direction < -22.5 && direction > -67.5){
        coll = Colors.lightBlue;
      } else if(direction <= -67.5 && direction >= -112.5){
        coll = Colors.blue[900];
      } else if(direction < -112.5 && direction > -157.5){
        coll = Colors.pink[200];
      } else if(direction <= -157.5 && direction >= 157.5){
        coll = Colors.orange;
      } else if(direction < 157.5 && direction > 112.5){
        coll = Colors.red[900];
      } else if(direction <= 112.5 && direction >= 67.5){
        coll = Colors.red;
      } else if(direction < 67.5 && direction > 22.5){
        coll = Colors.grey;
      } else{
        coll = Colors.black;
      }
    }
    return coll;
  }

  double? funny;

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        //appBar: AppBar(
        //  title: const Text('Flutter Compass'),
        //),
        body: Builder(builder: (context) {
          if (_hasPermissions) {
            return Stack(
              children: <Widget>[
                //_buildManualReader(),
                //_buildBack(),
                Expanded(child: _buildCompass()),
              ],
            );
          } else {
            return _buildPermissionSheet();
          }
        }),
      ),
    );
  }

  Widget _buildManualReader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          ElevatedButton(
            child: Text('Read Value'),
            onPressed: () async {
              final CompassEvent tmp = await FlutterCompass.events!.first;
              setState(() {
                _lastRead = tmp;
                _lastReadAt = DateTime.now();
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$_lastRead',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    '$_lastReadAt',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    var pic1 = "images/smile.png";
    var pic2 = "images/sad.png";
    var pic3 = "images/crying.png";
    var pic4 = "images/shocked.png";
    var pic5 = "images/happy.png";
    var pic6 = "images/weawymad.png";
    var pic7 = "images/kindamad.png";
    var pic8 = "images/unimpressed.png";

    String changeFace(double? direction){
      var picture;
      if(direction != null){
        if(direction <= 22.5 && direction >= -22.5) {
          picture = pic1;
        } else if(direction < -22.5 && direction > -67.5){
          picture = pic2;
        } else if(direction <= -67.5 && direction >= -112.5){
          picture = pic3;
        } else if(direction < -112.5 && direction > -157.5){
          picture = pic4;
        } else if(direction <= -157.5 && direction >= 157.5){
          picture = pic5;
        } else if(direction < 157.5 && direction > 112.5){
          picture = pic6;
        } else if(direction <= 112.5 && direction >= 67.5){
          picture = pic7;
        } else if(direction < 67.5 && direction > 22.5){
          picture = pic8;
        } else{
          picture = "images/compass.png";
        }
      }
      return picture;
    };

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;
        //for direction: NORTH=0, EAST=-90, SOUTH=180/-180, WEST=90
        print(direction);

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null)
          return Center(
            child: Text("Device does not have sensors!"),
          );

        return Material(
          shape: CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Transform.rotate(
              angle: (direction * (math.pi / 180) * -1),
              child: Image.asset(changeFace(direction)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Location Permission Required'),
          ElevatedButton(
            child: Text('Request Permissions'),
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('Open App Settings'),
            onPressed: () {
              openAppSettings().then((opened) {
                //
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildBack() {
    Color changeCol(double? direction){
      var col;
      if(direction != null){
        if(direction <= 22.5 && direction >= -22.5) {
          col = Colors.yellowAccent;
        } else if(direction < -22.5 && direction > -67.5){
          col = Colors.lightBlue;
        } else if(direction <= -67.5 && direction >= -112.5){
          col = Colors.blue[900];
        } else if(direction < -112.5 && direction > -157.5){
          col = Colors.pink[200];
        } else if(direction <= -157.5 && direction >= 157.5){
          col = Colors.orange;
        } else if(direction < 157.5 && direction > 112.5){
          col = Colors.red[900];
        } else if(direction <= 112.5 && direction >= 67.5){
          col = Colors.red;
        } else if(direction < 67.5 && direction > 22.5){
          col = Colors.grey;
        } else{
          col = Colors.black;
        }
      }
      return col;
    }

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {

        funny = snapshot.data!.heading;
        //for direction: NORTH=0, EAST=-90, SOUTH=180/-180, WEST=90

        // if direction is null, then device does not support this sensor
        // show error message

        return Expanded(
          child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(changeCol(funny)),
              ),
              onPressed: null,
              child: const Text(''),
            ),
        );
      },
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }
}