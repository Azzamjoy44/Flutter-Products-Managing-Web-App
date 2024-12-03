import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'products.dart';

class ManageProductsPage extends StatefulWidget {
  @override
  _ManageProductsPageState createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  // Text controllers for product name, price, and image URL input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  String? _selectedProductId; // Store the id of the product to edit
  bool _isEditing = false; // Track whether we are in edit mode or adding a new product

  // Function to save or update the product
  void _saveProduct() {
    // Check if any field is empty
    if (nameController.text.isEmpty || priceController.text.isEmpty || imageUrlController.text.isEmpty) {
      // Show alert dialog if any field is empty
      _showAlertDialog('Please fill out all fields before submitting.');
      return;
    }

    // Replace commas with periods in the price to handle different locales
    String priceText = priceController.text.replaceAll(',', '.');

    // Try to parse the price as a double
    double? price = double.tryParse(priceText);
    if (price == null) {
      _showAlertDialog('Please enter a valid number for the price.');
      return;
    }

    // If no product is selected, add a new product to Firestore
    if (_selectedProductId == null) {
      // Add new product if no product is selected for editing
      FirebaseFirestore.instance.collection('Products').add({
        'Name': nameController.text,
        'Price': price,
        'ImageUrl': imageUrlController.text,
      });
    } else {
      // If editing an existing product, update it in Firestore
      FirebaseFirestore.instance.collection('Products').doc(_selectedProductId).update({
        'Name': nameController.text,
        'Price': price,
        'ImageUrl': imageUrlController.text,
      });
    }

    // Reset form to initial state
    _clearFields();
  }

  // Function to delete a product from Firestore
  void _deleteProduct(String id) {
    FirebaseFirestore.instance.collection('Products').doc(id).delete();
  }

  // Reset form fields and edit mode
  void _clearFields() {
    nameController.clear();
    priceController.clear();
    imageUrlController.clear();
    setState(() {
      _selectedProductId = null;
      _isEditing = false; // Reset editing mode
    });
  }

  // Show an alert dialog with a custom message
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Input Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        centerTitle: false,  // Ensure the title is always aligned to the left
        actions: [
          // Button to navigate back to the products page
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProductPage()),
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Colors.purple.withOpacity(0.85),  // Default color when not interacting
              ),
              overlayColor: WidgetStateProperty.all(
                Colors.purple.withOpacity(1.0),  // Hover or press effect (slightly darker)
              ),  // Optional: background color
            ),
            child: Text(
              'View Products',
              style: TextStyle(
                color: Colors.white, // White text color
                fontSize: 18,         // Increase font size
                fontWeight: FontWeight.bold,  // Make text bold
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(  // Allow scrolling in case the content overflows
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [

                  // Text field for product name
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),

                  // Text field for price input (decimal allowed)
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),  // Allow decimal values
                  ),

                  // Text field for image URL input
                  TextField(
                    controller: imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                  ),
                  SizedBox(height: 10),

                  // Button to save product (changes text based on edit mode)
                  ElevatedButton(
                    onPressed: _saveProduct,
                    child: Text(_isEditing ? 'Save Changes' : 'Add Product'),
                  ),
                ],
              ),
            ),

            // StreamBuilder to display a list of products from Firestore
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Products').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var products = snapshot.data!.docs; // Get product list from Firestore

                return Column(
                  children: products.map<Widget>((product) {
                    var name = product['Name'];
                    var price = product['Price'];
                    var imageUrl = product['ImageUrl'];
                    var id = product.id;

                    return ListTile(
                      leading: Image.network(imageUrl, width: 50, height: 50),
                      title: Text(name),
                      subtitle: Text('$price lei'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // Button to edit product
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                                _selectedProductId = id;
                                nameController.text = name;
                                priceController.text = price.toString();
                                imageUrlController.text = imageUrl;
                              });
                            },
                          ),

                          // Button to delete product
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteProduct(id),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


