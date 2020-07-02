import 'dart:io';

import 'package:form_validation/src/model/producto_model.dart';
import 'package:form_validation/src/providers/producto_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final _productosController = BehaviorSubject<List<ProductoModel>>();

  final _cargandoController = BehaviorSubject<bool>();

  final _productosProvider = ProductosProvider();

  Stream<List<ProductoModel>> get productosStream =>
      _productosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void cargarProducto() async {
    final productos = await _productosProvider.cargarProductos();
    _productosController.sink.add(productos);
  }

  void agregarProducto(ProductoModel model) async {
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(model);
    _cargandoController.sink.add(false);
  }

  void editarProducto(ProductoModel model) async {
    _cargandoController.sink.add(true);
    await _productosProvider.editarProducto(model);
    _cargandoController.sink.add(false);
  }

  void borrarProducto(String id) async {
    await _productosProvider.borrarProducto(id);
  }

  Future<String> subirFoto(File photo) async {
    _cargandoController.sink.add(true);
    final photoUrl = await _productosProvider.subirImagen(photo);
    _cargandoController.sink.add(false);
    return photoUrl;
  }

  dispose() {
    _productosController.close();
    _cargandoController.close();
  }
}
