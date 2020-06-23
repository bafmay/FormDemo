import 'dart:convert';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:form_validation/src/model/producto_model.dart';

class ProductosProvider{

  final String _url = "https://flutterws-bc478.firebaseio.com";


  Future<bool> crearProducto(ProductoModel model) async{
    final url = '$_url/productos.json';
    
    final response = await http.post(url,body: productoModelToJson(model));
    final decodedData = json.decode(response.body);
    print(decodedData);
    return true;

  }

  Future<bool> editarProducto(ProductoModel model) async{
    final url = '$_url/productos/${model.id}.json';
    
    final response = await http.put(url,body: productoModelToJson(model));
    final decodedData = json.decode(response.body);
    print(decodedData);
    return true;

  }

  Future<List<ProductoModel>> cargarProductos() async{
    final url = '$_url/productos.json';
    
    final response = await http.get(url);
    final Map<String,dynamic> decodedData = json.decode(response.body);
    final List<ProductoModel> productos = List();
    if(decodedData == null) return [];
    

    decodedData.forEach((key, value) {
      final tmpModel = ProductoModel.fromJson(value);
      tmpModel.id = key;
      productos.add(tmpModel);
    });
    print(productos);
    return productos;
  }

  Future<int> borrarProducto(String id) async{
    final url = '$_url/productos/$id.json';
    
    final response = await http.delete(url);
    final decodedData = json.decode(response.body);
    print(decodedData);
    return 1;

  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dndudg32r/image/upload?upload_preset=rkyj3k6j');
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType(mimeType[0],mimeType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);
    if(response.statusCode != 200 && response.statusCode != 201){
      print('Algo salio mal');
      print(response.body);
      return null;
    }

    final respData = json.decode(response.body);
    return respData["secure_url"];
  }

}