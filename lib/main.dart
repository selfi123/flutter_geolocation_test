import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class GeolocationApp extends StatefulWidget {
  const GeolocationApp({super.key});

  @override
  State<GeolocationApp> createState() => _GeolocationAppState();
}


class _GeolocationAppState extends State<GeolocationApp> {

  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  String _currentAdress = "";


  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("Service disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  _getAdrressFromCoordinates() async {
    try {
      List<Placemark>placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAdress = "${place.locality}, ${place.country}";
      });
    }
    catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: const Text('Geolocation1'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.black87,

        ),
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Location coordinates",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text("Latitude= ${_currentLocation
                ?.latitude} ; Longitude = ${_currentLocation?.longitude}; "),
            const SizedBox(
              height: 30.0,
            ),
            const Text("Location address",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
             Text("${_currentAdress} "),
            const SizedBox(height: 50.0,),
            ElevatedButton(onPressed: () async {
              _currentLocation = await _getCurrentLocation();
              await _getAdrressFromCoordinates();

              print("${_currentLocation}");
              print("${_currentAdress}");
            }, child: const Text("get location"),

            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to HomePage
              },
              child: Text('Go Back'),
            ),
          ],
        )),
      );
    }
  }
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override Widget build(BuildContext context) { return Scaffold( appBar: AppBar(
    title: Text('Login'), ), body: Center( child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ Image.asset('assets/snims.png'),


            const SizedBox(height: 30),
            const Text( 'Sree Narayana Institute of Medical Sciences',
              style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, ), ),
            SizedBox(height: 20),
            TextFormField( decoration:
            InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(), ),
              validator: (value) { if (value == null || value.isEmpty)
              { return 'Please enter your email address'; } return null; },
            ),
            SizedBox(height: 20), TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password'; }
                return null; },
              obscureText: true, ),
            SizedBox(height: 30),
            ElevatedButton( onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
              // Handle login form submission
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GeolocationApp()),
                );
              }
              },
              child: Text('Log In'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), ), ),
            SizedBox(height: 20),
            Text( 'Forgot your password?',
              style:
              TextStyle( fontSize: 16, color: Colors.blue[700], ), ), ], ), ), ), ), ), );
  }
}
