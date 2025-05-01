import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/core/helper/logout.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/AccountScreen/CurrentProfileModel.dart';
import '../../config/themes/ThemeProvider.dart';
import '../home_view_user/presentation/pages/MainScreen.dart';
import 'ProfileApi.dart';
import 'package:easy_localization/easy_localization.dart';

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
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
          _errorMessage = 'auth_token_not_found'.tr();
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
          _displayNameController.text = _user?.displayName ?? '';
          _phoneController.text = _user?.phoneNumber ?? '';
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = '${'fetch_user_failed'.tr()} ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = '${'unexpected_error'.tr()} $error';
      });
    }
  }

  Future<void> _saveChanges() async {
    String newDisplayName = _displayNameController.text;
    String newPhoneNumber = _phoneController.text;

    bool success = await ProfileApi.updateProfile(
      displayName: newDisplayName,
      phoneNumber: newPhoneNumber,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('profile_updated'.tr())),
      );
      setState(() {
        if (_user != null) {
          _user!.displayName = newDisplayName;
          _user!.phoneNumber = newPhoneNumber;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('update_failed'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        actions: [
          ThemeSwitcher(),
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            final role = prefs.getString('role');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => MainScreen(isMerchant: role == 'Artisan'),
              ),
              (route) => false,
            );
          },
        ),
        centerTitle: true,
        title: Text(
          'edit_profile'.tr(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: theme.iconTheme.color,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text('${'error'.tr()}: $_errorMessage'))
              : _user == null
                  ? Center(child: Text('no_user_data'.tr()))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${'welcome'.tr()}, ${_user!.displayName ?? "N/A"}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          Text(
                            _user!.role.toString(),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 25),
                          _buildProfileField(
                            labelText: 'your_email'.tr(),
                            initialValue: _user!.email ?? "N/A",
                            isEditable: false,
                          ),
                          const SizedBox(height: 25.0),
                          _buildProfileField(
                            labelText: 'your_full_name'.tr(),
                            controller: _displayNameController,
                          ),
                          const SizedBox(height: 25.0),
                          _buildProfileField(
                            labelText: 'your_mobile_number'.tr(),
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 32.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor:
                                    theme.textTheme.labelLarge?.color,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                'save_changes'.tr(),
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.white),
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
    TextEditingController? controller,
    String? initialValue,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines = 1,
    bool isEditable = true,
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
            controller: controller,
            initialValue: initialValue,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            enabled: isEditable,
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

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(turns: animation, child: child);
        },
        child: IconButton(
          key: ValueKey<bool>(themeProvider.isDarkMode),
          icon: Icon(
            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            themeProvider.toggleTheme(!themeProvider.isDarkMode);
          },
        ),
      ),
    );
  }
}
