import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/provider/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Logan',
    'Aquaman',
    'Iroman',
    'Shazam'
  ];

  final peliculasReciente = [
    'Spiderman',
    'Capitan America'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // las acciones de muestro appBar icono de limpiar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        // metodo para cerrar
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que se muestran
    return Center(child: Container(
      height: 100.0,
      width: 100.0,
      color: Colors.blueAccent,
      child: Text(seleccion),
    ),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // son las sugerencias que aparecen cuando escriben
    if(query.isEmpty){ return Container();}

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('asses/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList() ,
          );
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
        
      },
    );


    // forma local de hacer una sugerencia
/* 
    final listaBusqueda = (query.isEmpty) 
                          ? peliculasReciente 
                          : peliculas.where(
                            (p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();


    return ListView.builder(
      itemCount: listaBusqueda.length,
      itemBuilder: (contex, i){
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaBusqueda[i]),
          onTap: (){
            seleccion = listaBusqueda[i];
            showResults(context);
          },
        );
      },
    ); */
  }

}