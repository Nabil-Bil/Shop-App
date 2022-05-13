import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  Product _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _imageUrlController = TextEditingController();

  Map _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  bool _isInit = true;
  bool _isLoad = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final productId = ModalRoute.of(context)!.settings.arguments as String;
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoad = true;
      });

      if (Provider.of<Products>(context, listen: false)
          .getIds
          .contains(_editedProduct.id)) {
        try {
          await Provider.of<Products>(context, listen: false)
              .updateProduct(_editedProduct.id, _editedProduct);
        } catch (e) {
          await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('An error occured!'),
                  content: const Text('Something went wrong'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Okey'),
                    )
                  ],
                );
              });
        } finally {
          setState(
            () {
              _isLoad = false;
            },
          );
          Navigator.of(context).pop();
        }
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (e) {
          await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('An error occured!'),
                  content: const Text('Something went wrong'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Okey'),
                    )
                  ],
                );
              });
        } finally {
          setState(
            () {
              _isLoad = false;
            },
          );
          Navigator.of(context).pop();
        }
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () => _saveForm(),
            icon: const Icon(
              Icons.save_outlined,
            ),
          ),
        ],
      ),
      body: _isLoad
          ? Center(
              child: CircularProgressIndicator(
              color: theme.colorScheme.secondary,
              strokeWidth: 5,
            ))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Title Is Required";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Price Is Required";
                        } else if (double.tryParse(value) == null) {
                          return "Invalid Price";
                        } else if (double.parse(value) <= 0) {
                          return "Price can't be less than 0";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value!),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      initialValue: _initValues['description'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Description Is Required";
                        } else if (value.length < 10) {
                          return "Should be at least 10 characters long.";
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'Image Preview',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Image.network(
                                  _imageUrlController.text,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return FittedBox(
                                        child: child,
                                        fit: BoxFit.fill,
                                      );
                                    }
                                    return Transform.scale(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 10,
                                        color: theme.colorScheme.primary,
                                      ),
                                      scale: 0.2,
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Image Url Invalid',
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        Expanded(
                          child: Focus(
                            onFocusChange: (value) {
                              if (!value) {
                                setState(() {});
                              }
                            },
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Image Url Is Required";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                labelText: 'Image Url',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value!,
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
