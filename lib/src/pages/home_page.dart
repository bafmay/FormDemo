import 'package:flutter/material.dart';
import 'package:form_validation/src/model/producto_model.dart';
import 'package:form_validation/src/providers/producto_provider.dart';

class HomePage extends StatelessWidget {
  
  final productosProvider = ProductosProvider();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page')
      ),
      body: _crearListado(),
      floatingActionButton: _crearFAB(context),
    );
  }

  FloatingActionButton _crearFAB(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'producto'),
      backgroundColor: Colors.deepPurple,
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder: (context,AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.hasData){
          final items = snapshot.data;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context,i) => _crearItem(context,items[i]),
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel model){
    return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direction){
            productosProvider.borrarProducto(model.id);
          },
          child: Card(
            child: Column(
              children: <Widget>[
                (model.fotoUrl == null) ? Image(image: AssetImage('assets/no-image.png')) 
                : FadeInImage(placeholder: AssetImage('assets/jar-loading.gif'), image: NetworkImage(model.fotoUrl),height: 300.0,width: double.infinity,fit: BoxFit.cover),
                ListTile(
                  title: Text('${model.titulo} - ${model.valor}'),
                  subtitle: Text(model.id),
                  onTap: () => Navigator.pushNamed(context, 'producto',arguments: model),
                ),
              ]
            ),
          )
    );
  }
}