import 'package:cosumodeapi/Pages/home_page.dart';
import 'package:cosumodeapi/Services/connectivity_service.dart';
import 'package:flutter/material.dart';

class ConnectivityPage extends StatefulWidget {
  const ConnectivityPage({super.key});

  @override
  State<ConnectivityPage> createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  late bool hasInternet;
  ConnectivityService cs = ConnectivityService();

  @override
  void initState() {
    super.initState();
    hasInternet = false;
    listChanges();
  }

  void listChanges() {
    cs.connectivityStream.listen((statusConnect) {
      setState(() {
        hasInternet = statusConnect;
      });

      if (statusConnect) {
        // Se tiver internet → vai para MyHomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(title: "CEP")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Status de conectividade")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasInternet ? Icons.wifi : Icons.wifi_off,
              size: 80,
              color: hasInternet ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Testar Internet"),
            ),
          ],
        ),
      ),
    );
  }
}
