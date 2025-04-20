import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/app_colors.dart';
import '../../config/routes_manager/routes.dart';
import '../../core/helper/logout.dart';
import 'currentUserModel.dart'; // استيراد الموديل الصحيح

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  CurrentUserModel? _user;
  bool _isLoading = true;
  String _errorMessage = '';
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('token');

      if (authToken == null || authToken.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Authentication token not found.';
        });
        return;
      }

      const String apiUrl =
          'http://abdoemam.runasp.net/api/Account/GetCurentUser';

      final response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        setState(() {
          _user = CurrentUserModel.fromJson(responseData);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Failed to fetch user data. Status code: ${response.statusCode}';
        });
      }
    } on DioException catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'DioError: ${error.message}';
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unexpected error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, Routes.homeRoute),
        ),
        centerTitle: true,
        title: const Text('Edit profile'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    'Error: $_errorMessage',
                    textAlign: TextAlign.center,
                  ),
                )
              : _user == null
                  ? const Center(
                      child: Text('No user data available.'),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Welcome, ${_user!.displayName ?? "N/A"}',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _user!.role.toString(),
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _user!.email ?? "N/A",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24.0),
                          _buildProfileField(
                            labelText: 'Your full name',
                            initialValue: _user!.displayName ?? "N/A",
                          ),
                          const SizedBox(height: 16.0),
                          _buildProfileField(
                            labelText: 'Your E-mail',
                            initialValue: _user!.email ?? "N/A",
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16.0),
                          _buildProfileField(
                            labelText: 'Your password',
                            initialValue: '********',
                            obscureText: true,
                          ),
                          const SizedBox(height: 16.0),
                          _buildProfileField(
                            labelText: 'Your mobile number',
                            initialValue: _user!.phoneNumber ?? "N/A",
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 32.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Implement save functionality
                                print('Changes saved');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text(
                                'save changes',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildProfileField({
    required String labelText,
    String? initialValue,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            initialValue: initialValue,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              suffixIcon: Icon(Icons.edit_outlined),
            ),
          ),
        ),
      ],
    );
  }
}
