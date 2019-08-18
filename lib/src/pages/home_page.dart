import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:peliculas/src/provider/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widget/card_swiper_widget.dart';
import 'package:peliculas/src/widget/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    // preguntar porque no fucnciona
    peliculasProvider.getPopulares();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en cine'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // codigo de busqueda flutter
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            peliculas: snapshot.data,
          );
        }
        return Container(
            height: 400.0, child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _footer(BuildContext context){

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead  )
          ),
          SizedBox(height: 5.0),

          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              
              if ( snapshot.hasData ) {
                return MovieHorizontal( 
                  peliculas: snapshot.data,
                  siguienePagina: peliculasProvider.getPopulares,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),

        ],
      ),
    );


  }

}
