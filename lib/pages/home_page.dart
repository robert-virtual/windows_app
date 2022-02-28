import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windows_app/pages/conexion_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class Conexion {
  String name;
  String host;
  Conexion({required this.host, required this.name});

  factory Conexion.fromJson(Map<String, dynamic> json) {
    return Conexion(
      name: json['name'],
      host: json['host'],
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'host': host,
      };
}

class _HomePageState extends State<HomePage> {
  
  List<Conexion> conexiones = [
    Conexion(host: "Angela", name: "Host"),
    Conexion(host: "Robert", name: "aws"),
    Conexion(host: "Emerson", name: "aws"),
    Conexion(host: "Mariela", name: "aws"),
    Conexion(host: "Daniel", name: "aws"),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conexiones"),
      ),
      body: ListView(
        children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: CupertinoContextMenu(
               child: const Text("Menu"),
               
               actions: const [
                  CupertinoContextMenuAction(child: Text("Eliminar"),),
                  CupertinoContextMenuAction(child: Text("Editar"),)
               ],
              ),
           ),
          for (Conexion item in conexiones)
            InkWell(
              
              onDoubleTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ConexionPage()));
              },
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(item.host),
                trailing: PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context)=>const [
                  PopupMenuItem(child: Text("Eliminar")),
                  PopupMenuItem(child: Text("Editar"))
                ]),
              ),
            )
        ],
      ),
      floatingActionButton: TextButton(
          onPressed: crearConexion, child: const Text("Crear conexion")),
    );
  }

  @override
  void initState() {
    loadConexines();
    super.initState();
  }

  void loadConexines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? string = prefs.getString("conexiones");
    setState(() {
      if (string != null) {
        List fromJson = List.from(jsonDecode(string));
        conexiones = fromJson.map((e) => Conexion.fromJson(e)).toList();
      }
    });
  }

  final nombre = TextEditingController();
  final host = TextEditingController();
  void guardarConexion() async {
    if (host.text.isNotEmpty && nombre.text.isNotEmpty) {
      Navigator.of(context).pop();
      conexiones.add(Conexion(host: host.text, name: nombre.text));
      host.clear();
      nombre.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("conexiones", jsonEncode(conexiones));
      setState(() {
        
      });
    }
  }

  Future<void> crearConexion() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Probar")),
              TextButton(
                  onPressed: guardarConexion, child: const Text("Guardar"))
            ],
            title: const Text("Crear Conexion"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nombre,
                        decoration: const InputDecoration(hintText: "Nombre"),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(hintText: "Usuario"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: host,
                        decoration: const InputDecoration(hintText: "Host"),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(hintText: "Contraseña"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
