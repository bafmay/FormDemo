import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/model/producto_model.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductosBloc productosBloc;
  ProductoModel producto = ProductoModel();
  bool _guardando = false;
  final picker = ImagePicker();
  File _photo;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) producto = prodData;
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Producto Page'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto,
            ),
            IconButton(icon: Icon(Icons.camera_alt), onPressed: _tomarFoto)
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _mostrarPhoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton()
                ],
              )),
        )));
  }

  Widget _crearNombre() {
    return TextFormField(
        initialValue: producto.titulo,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Producto'),
        onSaved: (value) => producto.titulo = value,
        validator: (value) =>
            value.length < 3 ? 'Ingrese el nombre del producto' : null);
  }

  Widget _crearPrecio() {
    return TextFormField(
        initialValue: producto.valor.toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: 'Precio'),
        onSaved: (value) => producto.valor = double.parse(value),
        validator: (value) => utils.isNumeric(value) ? null : 'Solo numeros');
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        value: producto.disponible,
        title: Text('Disponible'),
        activeColor: Colors.deepPurple,
        onChanged: (value) => setState(() {
              producto.disponible = value;
            }));
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.deepPurple,
        icon: Icon(Icons.save),
        textColor: Colors.white,
        label: Text('Guardar'),
        onPressed: (_guardando) ? null : _submit);
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (_photo != null) {
      producto.fotoUrl = await productosBloc.subirFoto(_photo);
    }

    if (producto.id == null)
      productosBloc.agregarProducto(producto);
    else
      productosBloc.editarProducto(producto);

    _mostrarSnackbar('Registro Guardado');

    Navigator.pop(context);
  }

  void _mostrarSnackbar(String msg) {
    final snackbar = SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarPhoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: AssetImage(_photo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  void _procesarImagen(ImageSource source) async {
    PickedFile _tmpPhoto = await picker.getImage(source: source);
    _photo = File(_tmpPhoto.path);

    if (_photo != null) {
      producto.fotoUrl = null;
    }

    setState(() {});
  }

  void _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  void _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }
}
