import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:support_local_artisans/core/di/di.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/Custom_label_text_field.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/custom_text_form_field.dart';
import 'package:support_local_artisans/core/utils/dialogs.dart';
import 'package:support_local_artisans/core/utils/validators.dart';
import 'package:support_local_artisans/features/register_view/presentation/manager/cubit/register_states.dart';
import '../../../../config/routes_manager/routes.dart';
import '../manager/cubit/register_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterScreenViewModel viewModel = getIt<RegisterScreenViewModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // String userType = 'عميل'; // نوع المستخدم الافتراضي
  // bool isArtisan = false; // هل المستخدم حرفي؟
  // final TextEditingController workshopAddressController =
  //     TextEditingController();
  // final TextEditingController specializationController =
  //     TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterScreenViewModel, RegisterStates>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is RegisterLoadingState) {
          DialogUtils.showLoadingDialog(context, message: "Loading....");
        } else if (state is RegisterErrorState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessageDialog(
            context: context,
            message: state.failures.errorMessage,
            posButtonTitle: "ok",
          );
        } else if (state is RegisterSuccessState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessageDialog(
            context: context,
            message: "Register Successfully.",
            posButtonTitle: "Ok",
            posButtonAction: () {
              Navigator.pushReplacementNamed(context, Routes.homeRoute);
            },
          );
        }
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xfff6f6f6),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/reglogo.png',
                        height: 130,
                      ),
                    ),
                    const CustomLabelTextField(label: "Full Name"),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      hint: "please enter full name",
                      keyboardType: TextInputType.text,
                      securedPassword: false,
                      validator: (text) {
                        if (text!.trim().isEmpty) {
                          return "this field is required";
                        }
                        return null;
                      },
                      controller: viewModel.nameController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const CustomLabelTextField(label: "Mobile Number"),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      hint: "please enter phone number",
                      keyboardType: TextInputType.number,
                      securedPassword: false,
                      validator: (text) {
                        if (text!.trim().isEmpty) {
                          return "this field is required";
                        }
                        AppValidators.isValidEgyptianPhoneNumber(text);
                        return null;
                      },
                      controller: viewModel.phoneController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const CustomLabelTextField(label: "Email Address"),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      hint: "please enter email address",
                      keyboardType: TextInputType.emailAddress,
                      securedPassword: false,
                      validator: (text) {
                        if (text!.trim().isEmpty) {
                          return "this field is required";
                        }
                        AppValidators.validateEmail(text);
                        return null;
                      },
                      controller: viewModel.emailController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const CustomLabelTextField(label: "Password"),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      hint: "please enter password",
                      keyboardType: TextInputType.text,
                      securedPassword: true,
                      validator: (text) {
                        if (text!.trim().isEmpty) {
                          return "this field is required";
                        }
                        AppValidators.validatePassword(text);
                        return null;
                      },
                      controller: viewModel.passwordController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const CustomLabelTextField(label: "Confirm Password"),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      hint: "please enter confirm password",
                      keyboardType: TextInputType.text,
                      securedPassword: true,
                      validator: (text) {
                        if (text!.isEmpty) {
                          if (text.trim().isEmpty) {
                            return "this field is required";
                          }
                          return "Please enter password";
                        }
                        if (viewModel.passwordController.text != text) {
                          return "Password doesn't match";
                        }
                        return null;
                      },
                      controller: viewModel.confirmPasswordController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // DropdownButtonFormField<String>(
                    //   value: userType,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       userType = value!;
                    //       isArtisan = value == 'حرفي';
                    //     });
                    //   },
                    //   items: ['عميل', 'حرفي'].map((type) {
                    //     return DropdownMenuItem(
                    //       value: type,
                    //       child: Text(type),
                    //     );
                    //   }).toList(),
                    //   decoration:
                    //       const InputDecoration(labelText: 'نوع المستخدم'),
                    // ),
                    //
                    // // الحقول الإضافية للحرفيين
                    // if (isArtisan) ...[
                    //   // عنوان الورشة
                    //   TextFormField(
                    //     controller: workshopAddressController,
                    //     decoration:
                    //         const InputDecoration(labelText: 'عنوان الورشة'),
                    //     validator: (value) {
                    //       if (isArtisan && (value == null || value.isEmpty)) {
                    //         return 'يرجى إدخال عنوان الورشة';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    //
                    //   // التخصص
                    //   TextFormField(
                    //     controller: specializationController,
                    //     decoration: const InputDecoration(labelText: 'التخصص'),
                    //     validator: (value) {
                    //       if (isArtisan && (value == null || value.isEmpty)) {
                    //         return 'يرجى إدخال التخصص';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // ],

                    Center(
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                          ),
                          onPressed: () {
                            //register();
                            if (formKey.currentState!.validate()) {
                              viewModel.register();
                            }
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Color(0xff012e2f),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have account?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.loginRoute);
                          },
                          child: Text(
                            "Log in",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: const Color(0xff1f526c),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
