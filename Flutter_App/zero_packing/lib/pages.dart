import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets.dart';
import '../globals.dart';
import '../models.dart';// 필요한 페이지 import

//  
//Provider 사용시 하위위젯으로 위젯트리안에 들어가야하는 이슈있음
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController userIdController;
  late TextEditingController userPasswordController;

  final _formKey = GlobalKey<FormState>();
  bool _obscureOption = true;

  void _login(BuildContext context) {
    // 로그인 로직...
    // 로그인 성공 시
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MenuScreen(), // Provider 제거
      ),
    );
  }

  @override
  void initState() {
    userIdController = TextEditingController();
    userPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    userIdController.dispose();
    userPasswordController.dispose();
    super.dispose();
  }

  Future<void> _takeUserInfoFromRegister(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));

    if (!context.mounted) return;
    if (result != null) {
      userIdController.text = result['email'] ?? '';
      userPasswordController.text = result['password'] ?? '';
      print(' 값 가져오기 ${result["email"]}, ${result["password"]}');
    } else {
      print('RegisterPage에서 결과값이 전달되지 않았습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Image.asset(
                'icons/logo.png',
                width: 200,
                height: 150,
              ),
            ),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                      controller: userIdController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: "사용자 이메일 주소",
                      autoFocus: true,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains("@")) {
                          return "이메일을 확인해주세요";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: userPasswordController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "사용자 비밀번호",
                        obscureText: _obscureOption,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureOption = !_obscureOption;
                            });
                          },
                          child: _obscureOption
                              ? const Icon(Icons.remove_red_eye)
                              : const Icon(Icons.lock_sharp),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 4) {
                            return "비밀번호를 확인해주세요";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // 로그인 로직 추가 (예: 서버 통신)
                    // 로그인 성공 시 _login(context) 호출
                    _login(context); // 로그인 성공 시 MenuScreen으로 이동
                  }
                },
                text: "로그인"),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPage()));
              },
              child: const Text(
                "비밀번호를 잊으셨나요?",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const Spacer(),
            CustomOutlinedButton(
                onPressed: () {
                  _takeUserInfoFromRegister(context);
                },
                text: "새 계정 만들기"),
            const SizedBox(height: 20),
            const Text(
              "PlayMate",
              style: TextStyle(color: Colors.grey),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController passwordCheckController;
  Map<String, String> registerInfo = {};

  bool _isVisible = true;
  final _formKey = GlobalKey<FormState>();

  _checkEmail() {
    final email = emailController.text;
    print('$email');
  }

  _register() {
    final email = emailController.text;
    final password = passwordController;
    final passwordCheck = passwordCheckController;
    registerInfo = {
      'email': emailController.text,
      'password': passwordController.text
    };
    print('$email , $password, $passwordCheck');
  }

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordCheckController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("회원가입"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("이메일 주소 입력"),
            const SizedBox(
              height: 10,
            ),
            const Text(
                "회원님에게 연락할 수 있는 이메일 주소를 입력하세요. 이 이메일 주소는 프로필에서 다른 사람에게 공개되지 않습니다"),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: "이메일 주소",
                autoFocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return "이메일을 확인해주세요";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _isVisible,
              child: CustomElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isVisible = false;
                      });
                      _checkEmail();
                    }
                  },
                  text: "다음"),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Visibility(
                  visible: !_isVisible,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: "비밀번호",
                          autoFocus: true,
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 4) {
                              return "비밀번호을 확인해주세요";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextField(
                          controller: passwordCheckController,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: "비밀번호확인",
                          autoFocus: true,
                          enableIMEPersonalizedLearning: false,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty || value.isEmpty) {
                              return "비밀번호확인 확인해주세요";
                            }
                            if (passwordCheckController.text != passwordController.text) {
                              return "비밀번호와비밀번허확인이 일치하지않습니다";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15,),
                      const Text("비밀번호생성규칙", textAlign: TextAlign.center,style: TextStyle(fontSize: 18, color: Colors.grey),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: RichText(text: const TextSpan(
                         
                          style: TextStyle(fontSize: 13, color: Colors.black,),
                          children: <TextSpan> [
                            TextSpan(text: "최소"),
                            TextSpan(text: " 8자", style: TextStyle(fontWeight:FontWeight.bold)),
                            TextSpan(text: " 반드시 "),
                            TextSpan(text: "대문자,소문자", style: TextStyle(fontWeight:FontWeight.bold)),
                            TextSpan(text: "를 포함합니다 또"),
                            TextSpan(text: " 숫자", style: TextStyle(fontWeight:FontWeight.bold)),
                            TextSpan(text: " 가 하나 이상포함되어야 하며"),
                            TextSpan(text: " 특수 문자", style: TextStyle(fontWeight:FontWeight.bold)),
                            TextSpan(text: " 를 하나이상 포함해야 합니다")
                        
                          ]
                        )),
                      ),
//                       최소 8자
// 반드시 대문자, 소문자를 포함해야 합니다.
// 숫자가 하나 이상 포함되어야 합니다.
// 특수 문자를 하나 이상 포함해야 합니다(예: ! @ # $ % ^ & *).
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  )),
            ),
            const Spacer(),
            Visibility(
              visible: !_isVisible,
              child: CustomElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()) {
                                _register();
                              Navigator.pop(context, registerInfo);
                            }
                            },
                            text: "완료"),
            ),
                          const SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}


class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  late TextEditingController _emailController;
  bool _showFAB = false;
  final _formKey = GlobalKey<FormState>();

  void _verifyEmail() {
  }

  void _checkEmail() {
    setState(() {
          _showFAB = _emailController.text.contains("@");
    });

  }

  void _sendResetMail() {
    print("New Password Sent : l15978!");
    _emailController.text = "";
  }

  @override void initState() {
    _emailController = TextEditingController();
    _emailController.addListener(_checkEmail);
    super.initState();
  }

  @override void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("비밀번호재설정"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Spacer(),
        const Text("이메일 주소 입력"),
        const SizedBox(height: 10,),
        const Text("해당 이메일주소로 비밀번호 재설정할수있는 메일을 보내드립니다"),
        const SizedBox(height: 15,),
        Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: "이메일 주소",
                autoFocus: true,
                enableIMEPersonalizedLearning: false,
                validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains("@")) {
                            return "이메일을 확인해주세요";
                          }
                          return null;
                        },
              ),
              ),
        ),
          const Spacer(),
          const SizedBox(height: 200,)
      ],
      ), 
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation,child: child);
        },
        child: _showFAB ? FloatingActionButton.extended(onPressed: (){
          if(_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                action: SnackBarAction(label: 'Ok', onPressed: () {
                  Navigator.pop(context);
                }
                ),
                content: const Text("비밀번호재설정 링크를 이메일로 보내드렸습니다"),
                duration: const Duration(milliseconds: 1500),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            );
          }
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        label: const Text("보내기"),
        icon: const Icon(Icons.mail_outline),
        ) : Container()
      )

      );
  }
}


class MenuScreen extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(id: '1', name: '후라이드 치킨', price: 15000),
    MenuItem(id: '2', name: '양념 치킨', price: 16000),
    MenuItem(id: '3', name: '간장 치킨', price: 17000),
    MenuItem(id: '4', name: '순살 치킨', price: 18000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메뉴'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('${item.price}원'),
            trailing: ElevatedButton(
              onPressed: () {
                Provider.of<OrderProvider>(context, listen: false)
                    .addToCart(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name}이(가) 장바구니에 추가되었습니다.')),
                );
              },
              child: Text('담기'),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장바구니'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final cartItems = orderProvider.cartItems;
          
          return cartItems.isEmpty
              ? Center(child: Text('장바구니가 비어 있습니다.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return ListTile(
                              title: Text(item.name),
                              subtitle: Text('${item.price}원'),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () {
                                  orderProvider.removeFromCart(item);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(labelText: '이름'),
                              enableIMEPersonalizedLearning: false,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '이름을 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(labelText: '전화번호'),
                              enableIMEPersonalizedLearning: false,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '전화번호를 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  orderProvider.createOrder(
                                      _nameController.text, _phoneController.text);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderListScreen()),
                                  );
                                }
                              },
                              child: Text('주문하기'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

class OrderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문 목록'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final orders = orderProvider.orders;
          
          return orders.isEmpty
              ? Center(child: Text('주문이 없습니다.'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return ListTile(
                      title: Text('${order.customerName}님의 주문'),
                      subtitle: Text(
                          '${order.items.map((item) => item.name).join(', ')} - ${order.orderTime.toString()}'),
                      trailing: order.isCompleted
                          ? Text('완료')
                          : ElevatedButton(
                              onPressed: () {
                                orderProvider.completeOrder(order);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('주문이 완료되었습니다.')),
                                );
                              },
                              child: Text('완료 처리'),
                            ),
                    );
                  },
                );
        },
      ),
    );
  }
}