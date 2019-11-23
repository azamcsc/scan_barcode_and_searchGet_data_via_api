/**********code with love by azamcsc***********/

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import 'dart:io';
//import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:load/load.dart';
//import 'package:flutter_launch/flutter_launch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:page_transition/page_transition.dart';


class Todo{
  final  passValue1;
  final  passValue2;

  Todo(this.passValue1, this.passValue2);
}

class Todo2{
  final  passValue3;

  Todo2(this.passValue3);
}

class Todo3{
  final  passValue1;
  final  passValue2;
  final  passValue3;
  final  passValue4;
  final  passValue5;

  Todo3(this.passValue1,this.passValue2,this.passValue3,this.passValue4,this.passValue5);
}

void main(){

  //Admob.initialize(getAppId());


  runApp(
    LoadingProvider(
      child: App(),
    ),
  );
}


/*String getAppId() {

    return 'ca-app-pub-2169890497317285~3193501754';

}*/



String username='';
String scanBarcode = '';
String msg = '';
var productName='';
var company='';
var brand='';
var imageP='';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMF BARCODE SCANNER',
      home: MainPage(),
    );

  }


}



class RegisterProduct extends StatefulWidget {

  final Todo todo;
  RegisterProduct({Key key,@required this.todo}):super(key: key);

  @override
  _RegisterProduct createState() => new _RegisterProduct(todo);


}

class DetailProduct extends StatefulWidget {

  final Todo3 todo3;
  DetailProduct({Key key,@required this.todo3}):super(key: key);

  @override
  _DetailProduct createState() => new _DetailProduct(todo3);


}


/*
class ImageInput extends StatefulWidget {
  final Todo2 todo2;
  ImageInput({Key key,@required this.todo2}):super(key: key);
  //var barcodeText2 = new TextEditingController();

  @override
  _ImageInput createState() => _ImageInput(todo2);


}
*/



class MainPage extends StatefulWidget  {
  @override
  _MainPageState createState() => new _MainPageState();


}


//////////////Open Mainpage section///////////////////////

class _MainPageState extends State<MainPage> {



  bool _btnReg = false;
  bool _btnDet = false;
  var _scanBarcode = '';
  var _msg = '';
  var _productName='';
  var _company='';
  var _brand='';
  var _imageP='no_image.png';
  final _formKey = GlobalKey<FormState>();

  //start function barcode

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666","", true)
        .listen((barcode) => print(barcode));
  }


  void iklanPopup()
  {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Info'),
            content: const Text(
                'Ini adalah version beta,Sekiranya anda berminat untuk sponsor untuk membagunkan aplikasi ini boleh wasap 01114991570(en_azam)'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }




// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String barcodeScanRes;
    _msg="";
    _productName='';
    _company='';
    _brand='';
    _imageP='no_image.png';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes =
      await FlutterBarcodeScanner.scanBarcode("#ff6666","", false);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted){
      return;


      //return;
    }

    setState(() {
      _scanBarcode = barcodeScanRes;
      var bar  = barcodeScanRes;
      connectApi(bar);
    });








  }

  Future connectApi(String scanBarcode) async {
    if(scanBarcode!="") {
      //var j = scanBarcode;
      Toast.show("Capaian ke pangkalan data..Sila tunggu..", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      showLoadingDialog(
        tapDismiss: false,
      );



      final response = await http.post(
          "http://your_domain_name/api.php", body: {
        "barcode": scanBarcode,
        "Token": "KjIookJHTg",
        "Task": "get"
      });

      var datareturn = json.decode(response.body);

      if (datareturn.length == 0) {
        setState(() {
          _msg = "No record";
          _productName = '-';
          _company = '-';
          _brand = '-';
          _imageP = 'no_image.png';
          _btnReg = true;
          _btnDet = false;
        });
        hideLoadingDialog();

        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Info'),
                content: const Text(
                    'Tiada rekod di temui, anda boleh mendaftar produk ini sekiranya anda pasti ia adalah produk muslim. Sama-sama kita meningkatkan ekonomi agama kita. #BMF'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
      } else {
        _msg = "Muslim product";
        _productName = datareturn[0]['productName'];
        _company = datareturn[0]['company'];
        _brand = datareturn[0]['brand'];
        _imageP = datareturn[0]['imageP'];
        _btnReg = false;
        _btnDet = true;

        setState(() {
          //var status_product= datareturn[0]['post_header'];
        });
        hideLoadingDialog();
      }

    }else{
      Toast.show("Tiada data barcode untuk di periksa.", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    }
  }

//////////close function barcode/////////////


  Widget build(BuildContext context) {

    _launchURL() async {
      const url = 'https://sponsorbmfscanner.wasap.my/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('BARCODE BMF SCANNER'),
        automaticallyImplyLeading: false,
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset('images/sponsor_2.jpg'),

            new SizedBox(height: _height/12,),
            new Image.asset('images/barcode.png'),
            //  new CircleAvatar(radius:_width<_height? _width/4:_height/4,backgroundImage: NetworkImage(imgUrl),),
            new SizedBox(height: _height/25.0,),
            new Text(_scanBarcode, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: _width/15, color: Colors.black),),
            // new Padding(padding: new EdgeInsets.only(top: _height/30, left: _width/8, right: _width/8),
            // child:new Text('_____________________________',
            //: new TextStyle(fontWeight: FontWeight.normal, fontSize: _width/25,color: Colors.white),textAlign: TextAlign.center,) ,),
            new Divider(height: _height/30,color: Colors.black,),
            new Row(
              children: <Widget>[
                rowCell('STATUS'),
                rowCell('='),
                rowCell(_msg),
              ],),
            new Divider(height: _height/30,color: Colors.black),
            new Padding(padding: new EdgeInsets.only(left: _width/8, right: _width/8), child: new FlatButton(  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                , onPressed: (){
              iklanPopup();
              initPlatformState();
            /*  label: Text('Sponsor'),
                  icon: Icon(Icons.settings_phone),
                  backgroundColor: Colors.pink,*/
            },
              child: new Container(child: new Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                new Icon(Icons.center_focus_strong,color: Colors.white,),
                new SizedBox(width: _width/30,),
                new Text('   SCAN BARCODE   ', style: TextStyle(color: Colors.white))
              ],)),color: Colors.blueAccent),),
            new Padding(padding: new EdgeInsets.only(left: _width/8, right: _width/8),
              child: _btnReg ? new FlatButton(  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                onPressed: (){
                  //initPlatformState();
                  //_scaffoldkey.currentState.openDrawer();
              navigateToRegisterProductPage(context,_scanBarcode,_msg);
                  },
                 child: new Container(child:  new Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                   new Icon(Icons.mode_edit,color: Colors.white,),
                   new SizedBox(width: _width/30,),
                   new Text('REGISTER PRODUCT', style: TextStyle(color: Colors.white))
              ],)),color: Colors.deepPurpleAccent,): SizedBox(),),
            new Padding(padding: new EdgeInsets.only(left: _width/8, right: _width/8), child: _btnDet ?  new FlatButton(  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              onPressed: (){

              navigateToDetailProductPage(context,_scanBarcode,_msg,_brand,_company,_productName);

              },
              child: new Container(child: new Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                new Icon(Icons.dehaze,color: Colors.white,),
                new SizedBox(width: _width/30,),
                new Text('PRODUCT DETAILS', style: TextStyle(color: Colors.white))
              ],)),color: Colors.teal,):SizedBox(),),
            new Padding(padding: new EdgeInsets.only(left: _width/8, right: _width/8),
              child:  new FlatButton(  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                onPressed: (){
                _launchURL();
               // FlutterLaunch.launchWathsApp(phone: "601114991570", message: "Hello");
                //
                // iklanPopup();
                  //initPlatformState();
                  //_scaffoldkey.currentState.openDrawer();
                 // navigateToRegisterProductPage(context,_scanBarcode,_msg);
                },
                child: new Container(child:  new Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                  new Icon(Icons.settings_phone,color: Colors.white,),
                  new SizedBox(width: _width/30,),
                  new Text('SPONSOR/IKLAN   ', style: TextStyle(color: Colors.white))
                ],)),color: Colors.pink,)),

           new Padding(padding: new EdgeInsets.only(left: _width/8, right: _width/8),
                child:new Container(
                )
            ),

/*
SizedBox(
              height: 70,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  child: Image.asset('images/doa.jpg',fit: BoxFit.fill,),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DoaPage()));

                    //navigateToSubPage(context);
                    //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Please waitt..'),));
                    //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Please wait'),));
                    //_dis
                    print("testt");
                  },
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), ),
                elevation: 100,
                margin: EdgeInsets.all(3),
              ),
            ),
              child: _btnReg ? new FlatButton(  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                onPressed: (){
                  //initPlatformState();
                  //_scaffoldkey.currentState.openDrawer();
              navigateToRegisterProductPage(context,_scanBarcode,_msg);
                  },
                 child: new Container(child:  new Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                   new Icon(Icons.mode_edit,color: Colors.white,),
                   new SizedBox(width: _width/30,),
                   new Text('REGISTER PRODUCT', style: TextStyle(color: Colors.white))
              ],)),color: Colors.blueAccent,): SizedBox(),),



            */




          ],
        ),
      ),

    );
  }



  Future navigateToRegisterProductPage(context,valueParam,valueParam2) async {

    Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade,  child: RegisterProduct(todo: new Todo(valueParam,valueParam2))));


  }

  Future navigateToDetailProductPage(context,valueParam,valueParam2,valueParam3,valueParam4,valueParam5) async {

    //Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProduct(todo3: new Todo3(valueParam,valueParam2,valueParam3,valueParam4,valueParam5))));
    Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade,  child:  DetailProduct(todo3: new Todo3(valueParam,valueParam2,valueParam3,valueParam4,valueParam5))));


  }

  Widget rowCell(String type) => new Expanded(child: new Column(children: <Widget>[
    new Text(type,style: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold,))
  ],));


}
//////////////Close MainPage section///////////////////////


//////////////open Register produk section///////////////////////
//class RegisterProduct extends StatelessWidget {
  class _RegisterProduct extends State<RegisterProduct> {
    Todo todo;
    _RegisterProduct(this.todo);

  //final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var barcodeText = new TextEditingController();
  var controllerJenama = new TextEditingController();
  var controllerSyarikat = new TextEditingController();
  var controllerProduct = new TextEditingController();


  void addData() async{

    if(barcodeText.text !="" && controllerJenama.text!="" && controllerSyarikat.text!="" && controllerProduct.text!=""){
      Toast.show("Sedang di muat naik...", context, duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
      showLoadingDialog(
        tapDismiss: false,
      );

   final response = await http.post("http://your_domain_name/api.php", body: {

    "BarcodeNo": barcodeText.text,//barcodeText,
    "Jenama": controllerJenama.text,
    "Syarikat": controllerSyarikat.text,
    "Product": controllerProduct.text,
    "Token": "KjIookJHTg",
    "Task": "put"
    });

    var datareturn = response.body;
    print(datareturn);


      hideLoadingDialog();
      showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Info'),
              content:  Text(datareturn),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: (){
                    Navigator.of(context).pop();
                    backToMainPage(context);
                  },
                )
              ],
            );
          }
      );

    }else
      {

        showDialog<void>(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Info'),
                content:  Text("Sila pastikan semua maklumat di isi."),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
        hideLoadingDialog();
      }

  }

  @override
  Widget build(BuildContext context) {
    barcodeText.text=todo.passValue1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk'),
        //backgroundColor: Colors.redAccent,
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              //key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextField(
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.burst_mode),
                      hintText: 'Barcode Number',
                      labelText: 'Barcode',
                    ),
                    controller: barcodeText,
                  ),
                  new TextField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.assignment),
                      hintText: 'cth:Beras Perang AAA',
                      labelText: 'Nama Produk',
                    ),
                    controller: controllerProduct,
                    //keyboardType: TextInputType.datetime,
                  ),
                  new TextField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.flag),
                      hintText: 'Cth:Faiza',
                      labelText: 'Jenama',
                    ),
                   controller: controllerJenama,
                   // keyboardType: read TextInputType.phone,
                    //inputFormatters: [
                      //WhitelistingTextInputFormatter.digitsOnly,
                    //],
                  ),
                  new TextField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.business),
                      hintText: 'Nama Syarikat dan No Pendaftaran SSM',
                      labelText: 'Syarikat',
                    ),
                    controller: controllerSyarikat,
                    //keyboardType: TextInputType.emailAddress,
                  ),

                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                    child:  new FlatButton(  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: (){
                        addData();
                        //initPlatformState();
                        //_scaffoldkey.currentState.openDrawer();
                        //navigateToRegisterProductPage(context,_scanBarcode,_msg);
                      },
                      child: new Container(child:  new Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                        new Icon(Icons.file_upload,color: Colors.white,),
                       // new SizedBox(width: _width/30,),
                        new Text('HANTAR', style: TextStyle(color: Colors.white))
                      ],)),color: Colors.blueAccent,)),
                 /* new Center(
                      child: AdmobBanner(
                        //adUnitId: "ca-app-pub-2169890497317285/7938416181",
                        adUnitId: "ca-app-pub-3940256099942544/6300978111",
                        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                      ),

                  ),

                  child: _btnReg ? new FlatButton(  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                onPressed: (){
                  //initPlatformState();
                  //_scaffoldkey.currentState.openDrawer();
              navigateToRegisterProductPage(context,_scanBarcode,_msg);
                  },
                 child: new Container(child:  new Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                   new Icon(Icons.mode_edit,color: Colors.white,),
                   new SizedBox(width: _width/30,),
                   new Text('REGISTER PRODUCT', style: TextStyle(color: Colors.white))
              ],)),color: Colors.blueAccent,): SizedBox(),),

                  */

                ],
              ))),







    );
  }

    void backToMainPage(context) {
      Navigator.push(context, PageTransition(type: PageTransitionType.size, alignment: Alignment.bottomCenter, child: MainPage()));
    }
 /* Future navigateToUploadImagePage(context,valueParam3) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageInput(todo2: new Todo2(valueParam3))));

  }*/
}
//////////////close Register produk section///////////////////////


//////////////open display product///////////////////////


class _DetailProduct extends State<DetailProduct> {



  Todo3 todo3;

  _DetailProduct(this.todo3);
  var barcodeText = new TextEditingController();
  var brandText = new TextEditingController();
  var companyText = new TextEditingController();
  var productText = new TextEditingController();
  //navigateToDetailProductPage(context,_scanBarcode,_msg,_brand,_company,_productName);







  @override
  Widget build(BuildContext context) {
    barcodeText.text=todo3.passValue1;
    brandText.text=todo3.passValue3;
    companyText.text=todo3.passValue4;
    productText.text=todo3.passValue5;

    void ulasanF(ulasan) async {
      print(ulasan);
      showLoadingDialog(tapDismiss: false,);
      final response = await http.post("http://your_domain_name/api.php",
          body: {
            "barcode": barcodeText.text,
            "Token": "KjIookJHTg",
            "Task": "complain",
            "ulasan": ulasan
          });
      var datareturn = response.body;
      Toast.show(datareturn, context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      hideLoadingDialog();


    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Maklumat Produk'),
        //backgroundColor: Colors.redAccent,
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
            //key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextField(
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.burst_mode),
                      hintText: 'Barcode Number',
                      labelText: 'Barcode',
                    ),
                    controller: barcodeText,
                  ),
                  new TextField(
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.assignment),
                      hintText: 'cth:Beras Perang AAA',
                      labelText: 'Nama Produk',
                    ),
                    controller: productText,
                    //keyboardType: TextInputType.datetime,
                  ),
                  new TextField(
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.flag),
                      hintText: 'Cth:Faiza',
                      labelText: 'Jenama',
                    ),
                    controller: brandText,
                    // keyboardType: read TextInputType.phone,
                    //inputFormatters: [
                    //WhitelistingTextInputFormatter.digitsOnly,
                    //],
                  ),
                  new TextField(
                    enabled: false,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.business),
                      hintText: 'Nama Syarikat dan No Pendaftaran SSM',
                      labelText: 'Syarikat',
                    ),
                    controller: companyText,
                    //keyboardType: TextInputType.emailAddress,
                  ),
                  Divider(
                    height: 2.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Text("LAPOR KESALAHAN DATA", style: TextStyle(color: Colors.white)),
                        color: Colors.red,
                        onPressed: (){
                          String ulasan = '';
                          return showDialog<String>(
                            context: context,
                            barrierDismissible: false, // dialog is dismissible with a tap on the barrier
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Sila nyatakan kesilapan dan sertakan maklumat yg betul.'),
                                content: new Row(
                                  children: <Widget>[
                                    new Expanded(
                                        child: new TextField(
                                          autofocus: true,
                                          decoration: new InputDecoration(
                                              labelText: 'Kesilapan', hintText: 'Kesilapan/Maklumat yg betul adalah ____'),
                                          onChanged: (value) {
                                            ulasan = value;
                                          },
                                        ))
                                  ],
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop(ulasan);

                                      ulasanF(ulasan);

                                    },
                                  ),
                                ],
                              );
                            },
                          );




                        }
                    ),
                  ),
                  Divider(
                    height: 2.0,
                  ),

                  new Center(
                    child: InkWell(
                      child: Image.asset('images/iklan1.gif',fit: BoxFit.fill,),
                      onTap: (){

                        _Iklan1();
                        print("testt");
                      },
                    ),

                  ),

 /*






 SizedBox(
              height: 70,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  child: Image.asset('images/iklan1.jpg',fit: BoxFit.fill,),
                  onTap: (){

                    print("testt");
                  },
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), ),
                elevation: 100,
                margin: EdgeInsets.all(3),
              ),
            ),




                  child: _btnReg ? new FlatButton(  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                onPressed: (){
                  //initPlatformState();
                  //_scaffoldkey.currentState.openDrawer();
              navigateToRegisterProductPage(context,_scanBarcode,_msg);
                  },
                 child: new Container(child:  new Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                   new Icon(Icons.mode_edit,color: Colors.white,),
                   new SizedBox(width: _width/30,),
                   new Text('REGISTER PRODUCT', style: TextStyle(color: Colors.white))
              ],)),color: Colors.blueAccent,): SizedBox(),),

                  */

                ],
              ))),







    );
  }

  _Iklan1() async {
    const url = 'https://bmfgazeboarenakraft.wasap.my/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}





///////////////close display product///////////////



//////////////Upload image section///////////////////////
/*
class _ImageInput extends State<ImageInput> {
   Todo2 todo2;
   _ImageInput(this.todo2);
  static final String uploadEndPoint = 'http://your_domain_name/api.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
   var parambarCode = new TextEditingController();
   bool _btnPic = false;


   chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
    _btnPic=true;

  }

  chooseImageCamera() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('');
    _btnPic=true;
  }

  setStatus(String message) {
     var alertMsj="";
    setState(() {
      status = message;
    });



     if(message=="0") {
       alertMsj = "Sedang di muat naik...";
       Toast.show(alertMsj, context, duration: Toast.LENGTH_LONG,
           gravity: Toast.CENTER);
       showLoadingDialog(
         tapDismiss: false,
       );
     }

  }

  startUpload(valueParamx) {
    setStatus('0');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName,valueParamx);
  }

  upload(fileName,barcodeEnd) {
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
      "Token": "scdscsw",
      "Task": "upload",
      "barcodeEnd": barcodeEnd,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);


      hideLoadingDialog();

        showDialog<void>(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Info'),
                content:  Text(result.statusCode == 200 ? result.body : errMessage),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: (){
                      Navigator.of(context).pop();
                      backToMainPage(context);
                    },
                  )
                ],
              );
            }
        );

     // }
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          _btnPic = false;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          if(base64Image!=null){
            _btnPic = true;
          }else{
            _btnPic=false;
          }

          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
         _btnPic = true;
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'Pilih gambar dari gallery atau camera',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
     parambarCode = todo2.passValue3;
    return Scaffold(
      appBar: AppBar(
        title: Text("Muat Naik Gambar"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              onPressed: chooseImage,
              child: Text('Gallery'),
            ),
            OutlineButton(
              onPressed: chooseImageCamera,
              child: Text('Camera'),
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            SizedBox(
              height: 20.0,
            ),
            _btnPic ? OutlineButton(
              child: Text('Hantar'),
              color: Colors.blueAccent,
              onPressed: () {
                startUpload(parambarCode.text);
              },
            ):
            SizedBox(
              height: 20.0,
            ),

          ],
        ),
      ),
    );
  }






   void backToMainPage(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
  }
}*/
//////////////close upload image section//////////////////////

