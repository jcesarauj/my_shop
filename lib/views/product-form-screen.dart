import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(() {
      print('mudou!!!');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isNotEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;

      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateImage() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool endWithPng = url.toLowerCase().endsWith('.png');
    bool endWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endWithJpge = url.toLowerCase().endsWith('.jpeg');

    return (startWithHttp || startWithHttps) &&
        (endWithPng || endWithJpg || endWithJpge);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
  }

  void _saveForm() {
    var isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    final product = new Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      price: _formData['price'],
      imageUrl: _formData['imageUrl'],
    );

    final products = Provider.of<Products>(context, listen: false);
    if (_formData['id'] == null) {
      products.addProduct(product);
    } else {
      products.updateProduct(product);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
                print(_formData.values);
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: _formData['title'],
                  decoration: InputDecoration(labelText: 'Titulo'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) => _formData['title'] = value,
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Informe um título válido!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _formData['price'].toString(),
                  decoration: InputDecoration(labelText: 'Preço'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) => _formData['price'] = double.parse(value),
                  validator: (value) {
                    bool isEmpty = value.trim().isEmpty;
                    var newPrice = double.tryParse(value);
                    bool isInValid = newPrice == null || newPrice <= 0;

                    if (isEmpty || isInValid) {
                      return 'Informe um preço válido';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _formData['description'],
                  decoration: InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) => _formData['description'] = value,
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Informe uma decrição válida!';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        initialValue: _formData['imageUrl'],
                        decoration: InputDecoration(labelText: 'URL da imagem'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        focusNode: _imageUrlFocusNode,
                        controller: _imageUrlController,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) => _formData['imageUrl'] = value,
                        validator: (value) {
                          bool isEmptyUrl = value.trim().isEmpty;
                          bool isInvalidUrl = !isValidImageUrl(value);

                          if (isEmptyUrl || isInvalidUrl) {
                            return 'Informe uma URL válida!';
                          }

                          return null;
                        },
                      ),
                    ),
                    Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.only(
                          top: 8,
                          left: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: _imageUrlController.text.isEmpty
                            ? Text('Informe a URL')
                            : FittedBox(
                                child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                              ))
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
