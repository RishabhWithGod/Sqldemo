import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqldemo/Screens/Controller.dart';
import 'package:sqldemo/Screens/Model.dart';

class ProductListScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: productController.productList.length,
          itemBuilder: (context, index) {
            final product = productController.productList[index];
            return ListTile(
              leading: product.imagePath.isNotEmpty
                  ? Image.file(File(product.imagePath))
                  : null,
              title: Text(product.name),
              subtitle: Text(product.description),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  productController.deleteProduct(product.id!);
                },
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ProductDialog(product: product),
                );
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ProductDialog(),
          );
        },
      ),
    );
  }
}

class ProductDialog extends StatelessWidget {
  final Product? product;

  ProductDialog({this.product});

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      nameController.text = product!.name;
      descriptionController.text = product!.description;
    }

    return AlertDialog(
      title: Text(product == null ? 'Add Product' : 'Edit Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          ElevatedButton(
            child: Text('Pick Image'),
            onPressed: () async {
              final imagePath = await productController.pickImage();
              if (imagePath != null) {
                // Use the picked image path
              }
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          child: Text('Save'),
          onPressed: () {
            final name = nameController.text;
            final description = descriptionController.text;
            // Add logic to save imagePath

            if (product == null) {
              productController.addProduct(Product(
                name: name,
                description: description,
                imagePath: '', // Add the correct image path here
              ));
            } else {
              productController.updateProduct(Product(
                id: product!.id,
                name: name,
                description: description,
                imagePath:
                    product!.imagePath, // Keep existing image path or update
              ));
            }

            Get.back();
          },
        ),
      ],
    );
  }
}
