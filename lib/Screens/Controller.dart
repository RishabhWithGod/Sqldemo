import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqldemo/Screens/DatabaseHelper.dart';
import 'package:sqldemo/Screens/Model.dart';


class ProductController extends GetxController {
  var productList = <Product>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    final products = await DatabaseHelper.instance.readAllProducts();
    productList.value = products;
  }

  void addProduct(Product product) async {
    await DatabaseHelper.instance.create(product);
    fetchProducts();
  }

  void updateProduct(Product product) async {
    await DatabaseHelper.instance.update(product);
    fetchProducts();
  }

  void deleteProduct(int id) async {
    await DatabaseHelper.instance.delete(id);
    fetchProducts();
  }

  Future<String?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }
}
