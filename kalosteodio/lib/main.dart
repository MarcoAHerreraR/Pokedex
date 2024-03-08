import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kalosteodio/model/poke.dart';
import 'package:http/http.dart' as http;
import 'package:kalosteodio/model/formas.dart' as Formas;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage()
        );

        }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


Future<Pokes> pokedex() async {
  String url = 'https://pokeapi.co/api/v2/pokemon?limit=72&offset=649';
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var pokes = Pokes.fromJson(data);
    return pokes;
  }else{
    throw Exception('fallo al cargar los pokemones');
  }
}

Future<Formas.Sprites> formas(int formas) async {
  String url = 'https://pokeapi.co/api/v2/pokemon-form/$formas';
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body)["sprites"];
    var pokes = Formas.Sprites.fromJson(data);
    return pokes;
  }else{
    throw Exception('fallo al cargar las imagenes');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> items = [];
  Future<Formas.Sprites> ?idseleccionado;
  
  @override
  void initState(){
    super.initState();
    pokedex();
    idseleccionado = formas(650);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       Column(
        children: [
          Expanded(
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.blue
                ),
                child: FutureBuilder(future: idseleccionado, builder: (context, snapshot) {
                  if (snapshot.hasData){
                    return Image.network(snapshot.data!.frontDefault.toString());
                  }else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                },),
            ),
          ),
          Expanded(
                child:Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 73, 162, 235)
                  ),
                  child: FutureBuilder<Pokes>(future:pokedex(),builder: (context, snapshot) {
                    if (snapshot.hasData){
                      Pokes posts = snapshot.data!;
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.8,
                          crossAxisCount: 5,
                          mainAxisSpacing: 10.00,
                          crossAxisSpacing: 10.00,
                        ),
                        itemCount: posts.results.length,
                        itemBuilder: (BuildContext context, int index) {
                        //var poke = posts.results[index].name;
                  
                      return /*Text("${poke.toString()}   ");*/
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            idseleccionado = formas(index+650);
                          });
                        },
                        child: Container(
                          height: MediaQuery.sizeOf(context).width/4.5,
                          decoration:const BoxDecoration(
                            color: Color.fromARGB(255, 22, 137, 231),
                            
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width/6,height: MediaQuery.sizeOf(context).width/6,
                                child: Image.network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index+650}.png",width: MediaQuery.sizeOf(context).width/6,fit: BoxFit.fill,height: MediaQuery.sizeOf(context).width/6,)),
                              Text((index + 650).toString())
                            ],
                          ),
                        ),
                      );});
                    }else if(snapshot.hasError){
                      return Center(
                        child: Text('Error;${snapshot.error}'),
                      );
                    }else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },),
                )
             
          )
        ],
      ),
    );
  }
}