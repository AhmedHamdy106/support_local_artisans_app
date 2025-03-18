import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:support_local_artisans/core/di/di.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/custom_label_text_field.dart';
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
  String selectedUserType = 'client';

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
            posButtonTitle: "OK",
          );
        } else if (state is RegisterSuccessState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessageDialog(
            context: context,
            message: "Register Successfully.",
            posButtonTitle: "OK",
            posButtonAction: () {
              Navigator.pushReplacementNamed(context, Routes.homeRoute);
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF8F0EC),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildTextField("Full Name", "Enter your full name", viewModel.nameController),
                  _buildTextField("Mobile Number", "Enter phone number", viewModel.phoneController, keyboardType: TextInputType.number),
                  _buildTextField("Email Address", "Enter your email", viewModel.emailController, keyboardType: TextInputType.emailAddress),
                  _buildTextField("Password", "Enter your password", viewModel.passwordController, isPassword: true),
                  _buildTextField("Confirm Password", "Confirm your password", viewModel.confirmPasswordController, isPassword: true),
                  const SizedBox(height: 20),
                  _buildUserTypeSelection(),
                  const SizedBox(height: 20),
                  _buildRegisterButton(),
                  _buildLoginOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 40),
          Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Text('Create an account to start your journey.', style: TextStyle(fontSize: 16, color: Color(0xff9D9896))),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLabelTextField(label: label),
        const SizedBox(height: 5),
        CustomTextFormField(
          hint: hint,
          keyboardType: keyboardType,
          securedPassword: isPassword,
          controller: controller,
          validator: (text) {
            if (text!.trim().isEmpty) return "This field is required";
            if (label == "Email Address") AppValidators.validateEmail(text);
            if (label == "Mobile Number") AppValidators.validatePhoneNumber(text);
            if (label == "Password") AppValidators.validatePassword(text);
            return null;
          }, prefixIcon: Image.asset("assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildUserTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildUserTypeCard('client', 'assets/images/3.0x/Group_3.0x.png'),
        const SizedBox(width: 10),
        _buildUserTypeCard('seller', 'assets/images/3.0x/Character_3.0x.png'),
      ],
    );
  }

  Widget _buildUserTypeCard(String type, String imagePath) {
    return GestureDetector(
      onTap: () => setState(() => selectedUserType = type),
      child: Container(
        width: 160,
        height: 165,
        decoration: BoxDecoration(
          color: selectedUserType == type ? Colors.brown.shade300 : const Color(0xffDDDAD9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<String>(
              value: type,
              groupValue: selectedUserType,
              onChanged: (value) => setState(() => selectedUserType = value!),
              activeColor: const Color(0xff8C4931),
            ),
            Text(type, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            Image.asset(imagePath, height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            viewModel.register(Role: selectedUserType == "client" ? "User" : "Artisan");
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff8C4931), padding: const EdgeInsets.symmetric(vertical: 15)),
        child: const Text('Sign Up', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }

  Widget _buildLoginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF9D9896))),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, Routes.loginRoute),
          child: const Text("Log In", style: TextStyle(fontSize: 16, color: Color(0xff8C4931))),
        ),
      ],
    );
  }
}
