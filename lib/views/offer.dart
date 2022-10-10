import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:dsi_bobooks/components/rounded_button.dart';
import 'package:dsi_bobooks/views/home_screen.dart';
import 'package:dsi_bobooks/views/mybooks.dart';
import 'package:dsi_bobooks/service/crud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:dsi_bobooks/constants/constants.dart';

class SellBooks extends StatefulWidget {
  @override
  _SellBooksState createState() => _SellBooksState();
}

class _SellBooksState extends State<SellBooks> {
  TextEditingController bookNameTEC = new TextEditingController();
  TextEditingController authorNameTEC = new TextEditingController();
  TextEditingController courseNameTEC = new TextEditingController();

  String bookImage =
      'https://w7.pngwing.com/pngs/1024/338/png-transparent-computer-icons-e-book-e-readers-book-purple-violet-logo.png';
  String defaultBookImage =
      'https://w7.pngwing.com/pngs/1024/338/png-transparent-computer-icons-e-book-e-readers-book-purple-violet-logo.png';

  List _myActivities;

  final _formKey = GlobalKey<FormState>();
  final formKeyMultiSelect = GlobalKey<FormState>();

  CRUDMethods crudMethods = new CRUDMethods();

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  bool spinner = false;
  bool isVisible = false;
  int _selectedYear;
  String appYear;
  List<String> allYears = [
    '1 Ensino Fundamental',
    '2 Ensino Fundamental',
    '3 Ensino Fundamental',
    '4 Ensino Fundamental',
    '1 Ensino Médio',
    '2 Ensino Médio',
    '3 Ensino Médio',
  ];

  List<DropdownMenuItem<int>> yearList = [
    DropdownMenuItem(
      child: Text('1 Ensino Fundamental'),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text('2 Ensino Fundamental'),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text('3 Ensino Fundamental'),
      value: 2,
    ),
    DropdownMenuItem(
      child: Text('4 Ensino Fundamental'),
      value: 3,
    ),
    DropdownMenuItem(
      child: Text('1 Ensino Médio'),
      value: 4,
    ),
    DropdownMenuItem(
      child: Text('2 Ensino Médio'),
      value: 5,
    ),
    DropdownMenuItem(
      child: Text('3 Ensino Médio'),
      value: 6,
    ),
  ];

  _saveForm() {
    var form = formKeyMultiSelect.currentState;
    form.validate();
    form.save();
    setState(() {
      print(_myActivities);
      if (_myActivities.length != 0) {
        setState(() {
          spinner = true;
        });

        crudMethods.addBooks(
          username: FirebaseAuth.instance.currentUser.displayName,
          email: FirebaseAuth.instance.currentUser.email,
          bookimg: bookImage,
          bookname: bookNameTEC.text,
          authorsname: authorNameTEC.text,
          coursename: courseNameTEC.text,
          year: appYear,
          branch: _myActivities,
        );

        Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyBooks()))
            .then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        });

        setState(() {
          spinner = false;
        });
      }
      // spinner = true;
    });
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _saveForm();
    }
  }

  File newProfilePic;
  Future getImage() async {
    var tempImg = await ImagePicker().getImage(source: ImageSource.gallery);
    newProfilePic = File(tempImg.path);

    setState(() {
      spinner = true;
    });
    uploadImage();
  }

  uploadImage() {
    String imgName = getRandomString(15);
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('bookimages/$imgName.jpg');

    StorageUploadTask task = firebaseStorageRef.putFile(newProfilePic);
    task.onComplete.then((value) async {
      print('##############feito#########');
      var newPhotoUrl = await value.ref.getDownloadURL();
      String strVal = newPhotoUrl.toString();
      setState(() {
        bookImage = strVal;
        isVisible = false;
        spinner = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    _myActivities = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2.5,
                                              padding: EdgeInsets.all(1.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: isVisible
                                                        ? Colors.red[700]
                                                        : Colors.black,
                                                    width: 1),
                                                shape: BoxShape.rectangle,
                                                color: Colors.black,
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      NetworkImage(bookImage),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    height: MediaQuery.of(context).size.height /
                                        3.5,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: isVisible
                                              ? Colors.red[700]
                                              : Colors.black,
                                          width: 1),
                                      shape: BoxShape.rectangle,
                                      color: Colors.grey[300],
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(bookImage),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width /
                                          2.0,
                                      top: MediaQuery.of(context).size.height /
                                          4.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.white,
                                      onPressed: () {
                                        getImage();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: isVisible,
                              child: Text(
                                'Por favor carregue uma imagem',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: TextFormField(
                                cursorColor: Colors.black,
                                controller: bookNameTEC,
                                keyboardType: TextInputType.emailAddress,
                                decoration: textFieldSellDecoration(
                                    'Digite o nome do livro'),
                                validator: (input) => (input.trim().length ==
                                            0 ||
                                        input.trim().length > 40)
                                    ? 'O nome deve ser menor ou igual a 40 caracteres'
                                    : null,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: TextFormField(
                                cursorColor: Colors.black,
                                controller: authorNameTEC,
                                decoration: textFieldSellDecoration(
                                    'Digite o nome do autor.'),
                                validator: (input) => (input.trim().length ==
                                            0 ||
                                        input.trim().length > 40)
                                    ? 'O nome deve ser menor ou igual a 40 caracteres'
                                    : null,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: TextFormField(
                                cursorColor: Colors.black,
                                controller: courseNameTEC,
                                decoration: textFieldSellDecoration(
                                    'Digite o nome da escola'),
                                validator: (input) => (input.trim().length ==
                                            0 ||
                                        input.trim().length > 40)
                                    ? 'O nome deve ser menor ou igual a 40 caracteres'
                                    : null,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 10.0),
                              child: DropdownButtonFormField(
                                decoration: textFieldSellDecoration(
                                    'Selecione sua série'),
                                items: yearList,
                                value: _selectedYear,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedYear = value;
                                    appYear = allYears[_selectedYear];
                                  });
                                },
                                isExpanded: true,
                                validator: (input) {
                                  return _selectedYear != null
                                      ? null
                                      : 'Selecione um valor';
                                },
                              ),
                            ),
                            Form(
                              key: formKeyMultiSelect,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    child: MultiSelectFormField(
                                      fillColor: Colors.transparent,
                                      validator: (value) {
                                        if (value == null ||
                                            value.length == 0) {
                                          return 'Selecione uma ou mais opções';
                                        } else {
                                          return '';
                                        }
                                      },
                                      dataSource: [
                                        {
                                          "display": "Livro didático",
                                          "value": "Livro didático",
                                        },
                                        {
                                          "display": "Livro paradidático",
                                          "value": "livro paradidático",
                                        },
                                      ],
                                      textField: 'display',
                                      valueField: 'value',
                                      okButtonLabel: 'OK',
                                      cancelButtonLabel: 'CANCELAR',
                                      title: Text(
                                        'Tipos',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      hintWidget: Text(
                                        'Por favor, selecione o tipo',
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                      // required: true,
                                      onSaved: (value) {
                                        if (value == null) return;
                                        setState(() {
                                          _myActivities = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: RoundedButton(
                                color: Colors.red[700],
                                txt: 'Publicar',
                                onpressed: () {
                                  if (bookImage == defaultBookImage) {
                                    setState(() {
                                      isVisible = true;
                                    });
                                  } else {
                                    setState(() {
                                      isVisible = false;
                                    });
                                    _submit();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
