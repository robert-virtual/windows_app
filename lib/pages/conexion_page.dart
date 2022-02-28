import 'package:flutter/material.dart';

class ConexionPage extends StatefulWidget {
  const ConexionPage({Key? key}) : super(key: key);

  @override
  State<ConexionPage> createState() => _ConexionPageState();
}

class _ConexionPageState extends State<ConexionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conexion"),

      ),
      body: const Center(
        child: Text("Conexion Page"),
      ),
    );
  }
}