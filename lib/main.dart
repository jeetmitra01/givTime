import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:give_time/DBHelper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Ngoobj.dart';
import 'dart:async';
import 'Ngo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';


void main() {
  runApp(
    MaterialApp(
      home: HomeWidget(),
      
    ),
  );
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  
  
  

  

  @override
  Widget build(BuildContext context) {

    var futureBuilder = new FutureBuilder(
      future: DbHelper.db.getAllNgo(),
      builder:(BuildContext context, AsyncSnapshot snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: new CircularProgressIndicator());
            
          default:
            if (snapshot.hasError) {
              return new Text("Error: ${snapshot.error}");

            }
            else 
              return createListView(context, snapshot);
        }
      }
    );

    return Scaffold(
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'givTime',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ],
          )
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("givTime"),
      ),
      body: futureBuilder, 
    );
  }
}

Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
  List<Ngo> ngos  = snapshot.data;
  return new ListView.builder(
        itemCount: ngos.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, int) {
          return InkWell(
              child: ngoCard(ngos[int]),
              splashColor: Colors.lightBlue[300],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context)=>NgoPage(ngoDeets: ngos[int]),
                    ),
                );
              }
            );
        },
      );

}
Widget ngoCard(ngo){

    print(ngo.description);
    print(ngo.longitude);
    print(ngo.imageurl);
    print(ngo.name);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: "Ngo${ngo.name}",
              child: Image(
                image: NetworkImage(ngo.imageurl),

              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0,1.0),
              child: Text(
                ngo.name,
                style: TextStyle(
                  fontSize: 14,
                )

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                ngo.description,
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 12,
                )

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                " tags: ${ngo.work}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),

              ),
            )
          ],
        ),
      )
    );
  }

class NgoPage extends StatefulWidget {
  Ngo ngoDeets;

  NgoPage({Key key, @required this.ngoDeets}) : super(key: key);
  @override
  _NgoPageState createState() => _NgoPageState(detailedNgo: ngoDeets);
}

class _NgoPageState extends State<NgoPage> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  Ngo detailedNgo;
  _NgoPageState({Key key, @required this.detailedNgo}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("givTime"),
      ),
      body: ListView(
        children: <Widget>[
          Hero(
            tag: "N",
            child: Image(
              image: NetworkImage(detailedNgo.imageurl),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              detailedNgo.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              detailedNgo.description,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 1.0, 0.0, 1.0),
            child: Divider(
              thickness: 2.0,

            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 1.0, 12.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  detailedNgo.phone,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Ink(
                  decoration: ShapeDecoration(
                    color: Colors.lightBlue,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.phone),
                    color: Colors.white,
                    onPressed: () async => { await launch("tel: ${detailedNgo.phone}")},
                  ),
                ),
              ],
            ),
          ),

          Padding(
              padding: EdgeInsets.fromLTRB(12.0, 1.0, 12.0, 12.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      detailedNgo.email,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Ink(
                      decoration: ShapeDecoration(
                        color: Colors.lightBlue,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.email_outlined),
                        color: Colors.white,
                        onPressed: () async => { await launch("mailto:${detailedNgo.email}")},
                      ),
                    ),
                  ],
              ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(12.0, 1.0, 12.0, 12.0),
              child: InkWell(
                onTap: () => MapsLauncher.launchCoordinates(
                    double.parse(detailedNgo.latitude), double.parse(detailedNgo.longitude), '${detailedNgo.name}'),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image(
                        image: AssetImage('assets/maps.jpeg'),
                      ),
                    ),
                    Text(
                      "Go to ${detailedNgo.name}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 13.0),
            child: Text(
              detailedNgo.area,
              style:TextStyle(
                color: Colors.grey[800],
                fontSize: 15,
              ),
            ),
          )
          // uncomment if map is added
          // Container(
          //   width: 0.80*MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          //   child: GoogleMap(
          //     onMapCreated: _onMapCreated,
          //     initialCameraPosition: CameraPosition(
          //       target: _center,
          //       zoom: 11.0,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
