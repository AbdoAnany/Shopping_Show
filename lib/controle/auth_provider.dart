import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:panda1/models/Cart.dart';
import 'package:panda1/models/Product.dart';
import 'package:panda1/screens/add_product/add_product_screen.dart';
import 'package:panda1/screens/home/home_screen.dart';
import 'package:panda1/screens/sign_in/sign_in_screen.dart';

enum MenuState { home, favourite, message, profile }
enum AuthStates { unAuthentication, Authenticating, Authenticated }
var userid;
var type = 'customer';

String billID;
List popItem = [
  'الاكثر شيوعا', 'قسم كاشات', 'قسم أطفالي', 'قسم داخلي حريمي', 'قسم لانجري',
  ' أسدالات', 'قسم عبايات حريمي', 'قسم التركي', 'قسم الترنجات الحريمي',
  'قسم الترنجات الرجالي', 'قسم ترنجات بنات', 'ملابس', 'أكسسوارات'
//  'أغذية و مشروبات',
  //'لحوم و دواجن',داخلي
  // 'أسماك',
  // 'مخبوزات',
//  'خضراوات و فاكهة',
//  'مجمدات',
//  'أجبان',

  // 'منتجات بنده',
  // 'منظيفات',
//  'أدوات منزلية',
//  'أدوات بحر',
  // 'أدوات منزلية',
  // 'عروض خاصة',
//  'أجهزه الكترونية',
//  'منتجات'
];

String imagePath = '';

class AuthProvider with ChangeNotifier {
  final urlPost = Uri.parse('https://morning-bayou-24260.herokuapp.com/post');
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseMessaging _fbm = FirebaseMessaging();
  AuthStates _authStates = AuthStates.unAuthentication;
  FirebaseAuth _instance;
  User _user;

  var bill, bill1 = [], save1 = [], users;
  User get user => _user;
  AuthStates get authStates => _authStates;
  AuthProvider() {
    _instance = FirebaseAuth.instance;
    _instance.authStateChanges().listen((User user) {
      if (user == null) {
        _authStates = AuthStates.unAuthentication;
      } else {
        _user = user;
        _authStates = AuthStates.Authenticated;
      }
      notifyListeners();
    });
  }

  void checkSignIn(context) async {
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user == null) {
        Navigator.pushReplacementNamed(context, SignInScreen.routeName);
      } else {
        _user = user;
        userid = _user.uid;
        notifyListeners();
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    });
  }

  //---------------Notifications with Firebase---------------------------
  usertype(context) async {
    if (userid != null) {
      var c = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .get();
      type = await c.data()['type'];
      if (type == 'admin')
        Navigator.pushNamed(context, AddProductScreen.routeName);
    }
  }

  Future notifications() async {
    if (Platform.isIOS)
      _fbm.requestNotificationPermissions(IosNotificationSettings());

    _fbm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage ==>$message");
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch ==>$message");
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume ==>$message");
    });
    _fbm.requestNotificationPermissions(
        const IosNotificationSettings(alert: true, sound: true, badge: true));
    notifyListeners();
  }

  //---------------Login With Email and Password---------------------------
  Future<String> login(String email, String password) async {
    try {
      _authStates = AuthStates.Authenticating;
      notifyListeners();
      UserCredential userCredential = await _instance
          .signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      users = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .get();
      userid = _user.uid;

      _authStates = AuthStates.Authenticated;
      notifyListeners();
      return 'success';
    } on FirebaseAuthException catch (e) {
      _authStates = AuthStates.unAuthentication;
      notifyListeners();
      return e.message;
    }
  }

  //---------------SignIn with google account---------------------------
  void googleSignIn() async {
    try {
      final GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
      notifyListeners();
      GoogleSignInAuthentication signInAuthentication =
          await signInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: signInAuthentication.idToken,
          accessToken: signInAuthentication.accessToken);
      await _instance.signInWithCredential(credential);
      _user = _instance.currentUser;
      await FirebaseFirestore.instance.collection('users').doc(_user.uid).set({
        "name": 'name',
        "phone": 'phone',
        "type": 'Customer',
      });
      userid = _user.uid;
      //   users=   await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
      notifyListeners();
    } catch (error) {
      notifyListeners();
    }
  }

  //---------------Registration---------------------------
  Future<String> register(
      String name, String phone, String email, String password) async {
    try {
      _authStates = AuthStates.Authenticating;
      notifyListeners();
      UserCredential userCredential = await _instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      _user.updateProfile(displayName: name);
      await FirebaseFirestore.instance.collection('users').doc(_user.uid).set({
        "name": name,
        "phone": phone,
        "type": 'customer',
      });

      return 'success';
    } on FirebaseAuthException catch (e) {
      _authStates = AuthStates.unAuthentication;
      notifyListeners();
      return e.message;
    }
  }

  Future<String> account(String name, String phone, String email,
      String password, String address) async {
    try {
      _authStates = AuthStates.Authenticating;
      notifyListeners();
      await FirebaseFirestore.instance.collection('users').doc(_user.uid).set({
        "name": name,
        "phone": phone,
        "type": 'Customer',
        "address": address,
      });

      return 'success';
    } on FirebaseAuthException catch (e) {
      _authStates = AuthStates.unAuthentication;
      notifyListeners();
      return e.message;
    }
  }

  //---------------logOut with google account or email---------------------------
  logOut(context) async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
      _authStates = AuthStates.unAuthentication;
      notifyListeners();
      return;
    }
    await _instance.signOut();
    _authStates = AuthStates.unAuthentication;
    notifyListeners();

    Navigator.pushNamed(context, SignInScreen.routeName);
    return;
  }

  //---------------Add Bill in Firebase---------------------------
  Future<String> addBill(List<Cart> bill, address, total) async {
    bill1.clear();
    bill.forEach((element) {
      bill1.add({
        'title': '${element.product.title}',
        'price': '${element.product.price}',
        'num': '${element.numOfItem}'
      });
    });
    if (bill == null || bill.isEmpty) {
      return null;
    }
    var dateTime = DateTime.now();
    dateTime.format('D, M j, H:i');
    try {
      await FirebaseFirestore.instance
          .collection('bills')
          .doc(_user.uid)
          .collection(_user.email)
          .doc()
          .set({
        'bill': bill1,
        'total': double.parse((total.toStringAsFixed(2))),
        'date': dateTime.format(DateTimeFormats.american),
        'len': bill1.length,
        'address': address,
        'state': 'مسودة'
      });
      notifyListeners();
      return 'success';
    } on FirebaseAuthException catch (e) {
      notifyListeners();
      return e.message;
    }
  }

  Future<String> deleteBill(docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bills')
          .doc(_user.uid)
          .collection('bill')
          .doc(docId)
          .delete();
      notifyListeners();
      return 'success';
    } on FirebaseAuthException catch (e) {
      notifyListeners();
      return e.message;
    }
  }

  Future<String> addProduct(Product product) async {
    notifyListeners();
    if (product == null) {
      return null;
    }
    var dateTime = DateTime.now();
    product.date = dateTime.format(DateTimeFormats.american);
    dateTime.format('D, M j, H:i');

    product.id = Random().nextInt(100000) + DateTime.now().millisecond;
    print(product.id);
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.category)
          .collection(product.category)
          .add({
        'product': product.toMaps(),
        'category': product.category,
        'date': dateTime.format(DateTimeFormats.american),
      });
      notifyListeners();

      return 'success';
    } on FirebaseAuthException catch (e) {
      notifyListeners();
      return e.message;
    }
  }

  Future<String> deleteProduct(docId, id) async {
    try {
      print(id);
      await FirebaseFirestore.instance
          .collection('products')
          .doc(docId)
          .collection(docId)
          .doc(id)
          .delete();
      notifyListeners();
      return 'success';
    } on FirebaseAuthException catch (e) {
      notifyListeners();
      return e.message;
    }
  }

//---------------get All Exam from Firebase---------------------------
  Future<String> uploadImageToFirebase(
      File image, category, title, barcode) async {
    notifyListeners();
    try {
      String imageLocation = '${category}/${title}_${barcode}.jpg';
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(imageLocation);
      final UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() async {
        imagePath = await addPathToDatabase(imageLocation);
        notifyListeners();
      });
    } catch (e) {
      print(e.message);
    }
  }

  Future<String> addPathToDatabase(String text) async {
    try {
      // Get image URL from firebase
      final imagePath = FirebaseStorage.instance.ref('$text').getDownloadURL();

      notifyListeners();
      print(imagePath);

      return imagePath;
    } catch (e) {
      print(e.message);
      showDialog(
          //    context: context,
          builder: (context) {
        return AlertDialog(
          content: Text(e.message),
        );
      });
    }
  }

  Future showAlert(String error, myContext) async {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: myContext,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  error,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          );
        });
  }
}
