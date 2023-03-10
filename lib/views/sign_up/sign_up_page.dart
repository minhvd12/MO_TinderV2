import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';
import '../../constants/route.dart';
import '../../models/request/sign_up_request.dart';
import '../../repositories/implement/auth_implement.dart';
import '../../constants/url_api.dart';
import '../../widgets/button/button.dart';
import '../../widgets/input/input_field.dart';
import '../../widgets/input/password_field.dart';
import '../pages/otp_validation_page.dart';
import '../sign_in/already_have_an_account_check.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  bool _isNewPasswordEightCharacters = false;
  bool _hasNewPasswordOneNumber = false;
  bool _matchingPassword = false;
  final formKey = GlobalKey<FormState>();

  onNewPasswordChange(String newPassword) {
    final numericRegex = RegExp(r'[0-9]');
    setState(
      () {
        _isNewPasswordEightCharacters = false;
        if (newPassword.length >= 8) _isNewPasswordEightCharacters = true;
        _hasNewPasswordOneNumber = false;
        if (numericRegex.hasMatch(newPassword)) _hasNewPasswordOneNumber = true;
        _confirmPassword.clear();
      },
    );
  }

  onMatchingPassword(String password) {
    setState(
      () {
        _matchingPassword = false;
        if (_password.text == _confirmPassword.text) {
          _matchingPassword = true;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          '????ng K??',
          style: AppTextStyles.h3Black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 100.h,
          color: AppColor.primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    ImagePath.create,
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        InputField(
                          hintText: "S??? ??i???n tho???i",
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          controller: _phone,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "S??? ??i???n tho???i kh??ng ???????c tr???ng";
                            } else if (value != null && value.length != 10) {
                              return "S??? ??i???n tho???i ph???i l?? 10 s???";
                            } else {
                              return null;
                            }
                          },
                        ),
                        InputField(
                          hintText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          controller: _email,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Email kh??ng ???????c tr???ng";
                            } else if (value != null &&
                                !RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$')
                                    .hasMatch(value)) {
                              return "Email kh??ng ????ng ?????nh d???ng";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  PasswordField(
                    hintText: "M???t kh???u",
                    textInputAction: TextInputAction.next,
                    controller: _password,
                    onChanged: (newPassword) =>
                        onNewPasswordChange(newPassword),
                    validator: null,
                  ),
                  PasswordField(
                    hintText: "Nh???p l???i m???t kh???u",
                    textInputAction: TextInputAction.done,
                    controller: _confirmPassword,
                    onChanged: (password) => onMatchingPassword(password),
                    validator: null,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 500,
                              ),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _isNewPasswordEightCharacters
                                    ? AppColor.success
                                    : Colors.transparent,
                                border: _isNewPasswordEightCharacters
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(
                                        color: AppColor.grey,
                                      ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: AppColor.primary,
                                  size: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            const Text("M???t kh???u ph???i t??? 8 k?? t??? tr??? l??n"),
                          ],
                        ),
                        SizedBox(
                          height: 2.w,
                        ),
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 500,
                              ),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _hasNewPasswordOneNumber
                                    ? AppColor.success
                                    : Colors.transparent,
                                border: _hasNewPasswordOneNumber
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(
                                        color: AppColor.grey,
                                      ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: AppColor.primary,
                                  size: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            const Text("M???t kh???u ph???i ch???a ??t nh???t 1 con s???"),
                          ],
                        ),
                        SizedBox(
                          height: 2.w,
                        ),
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 500,
                              ),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _matchingPassword
                                    ? AppColor.success
                                    : Colors.transparent,
                                border: _matchingPassword
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(
                                        color: AppColor.grey,
                                      ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: AppColor.primary,
                                  size: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            const Text(
                                "M???t kh???u nh???p l???i ph???i kh???p v???i m???t kh???u"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ButtonDefault(
                      width: 80.w,
                      height: 7.h,
                      content: '????ng K??',
                      textStyle: AppTextStyles.h3White,
                      backgroundBtn: AppColor.btnColor,
                      voidCallBack: () {
                        final isValidForm = formKey.currentState!.validate();

                        if (isValidForm &&
                            _isNewPasswordEightCharacters &&
                            _hasNewPasswordOneNumber &&
                            _matchingPassword) {
                          AuthImplement()
                              .signUp(
                                  UrlApi.applicant,
                                  SignUpRequest(
                                      phone: _phone.text,
                                      password: _password.text,
                                      email: _email.text))
                              .then((value) => {
                                    if (value.data!.phone != "exist")
                                      {
                                        AuthImplement()
                                            .getOTP(UrlApi.SMS, _phone.text)
                                            .then((value) => {
                                                  if (value != "Fail")
                                                    {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return OTPValidationPage(
                                                          phone: _phone.text,
                                                          forgot: false,
                                                        );
                                                      })),
                                                    }
                                                }),
                                      }
                                  });
                        }
                      }),
                  SizedBox(
                    height: 2.h,
                  ),
                  AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        setState(() {
                          Navigator.of(context).pushNamed(
                            RoutePath.signInRoute,
                          );
                        });
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
