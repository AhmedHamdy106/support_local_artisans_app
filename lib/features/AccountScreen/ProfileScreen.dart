import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:support_local_artisans/core/helper/logout.dart';
import 'package:support_local_artisans/features/AccountScreen/CurrentProfileModel.dart';
import '../../config/themes/AppColorsLight.dart';
import '../../config/themes/ThemeProvider.dart';
import '../home_view_user/presentation/pages/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProfileApi.dart';

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

          // Set the initial values in the text fields
          _displayNameController.text = _user?.displayName ?? '';
          _phoneController.text = _user?.phoneNumber ?? '';
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
          'Failed to fetch user data. Status code: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unexpected error: $error';
      });
    }
  }

  // Function to handle save changes
  Future<void> _saveChanges() async {
    String newDisplayName = _displayNameController.text;
    String newPhoneNumber = _phoneController.text;

    // Update the user profile using the UserApi
    bool success = await ProfileApi.updateProfile(
      displayName: newDisplayName,
      phoneNumber: newPhoneNumber,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      setState(() {
        // Update the local model
        if (_user != null) {
          _user!.displayName = newDisplayName;
          _user!.phoneNumber = newPhoneNumber;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // استخدام خلفية الثيم
      appBar: AppBar(
        actions: [
          // زرار تغيير الثيم
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
        title: const Text('Edit profile'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.iconTheme.color, // استخدام اللون المناسب من الثيم
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text('Error: $_errorMessage'))
          : _user == null
          ? const Center(child: Text('No user data available.'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome, ${_user!.displayName ?? "N/A"}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color, // استخدام النص من الثيم
              ),
            ),
            Text(
              _user!.role.toString(),
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color, // استخدام النص من الثيم
              ),
            ),
            const SizedBox(height: 25),
            _buildProfileField(
              labelText: 'Your E-mail',
              initialValue: _user!.email ?? "N/A",
              isEditable: false, // Make email field non-editable
            ),
            const SizedBox(height: 25.0),
            _buildProfileField(
              labelText: 'Your full name',
              controller: _displayNameController,
            ),
            const SizedBox(height: 25.0),
            _buildProfileField(
              labelText: 'Your mobile number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor, // استخدام اللون الأساسي من الثيم
                  foregroundColor: theme.textTheme.labelLarge?.color,
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
    TextEditingController? controller,
    String? initialValue,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines = 1,
    bool isEditable = true, // Flag to determine if the field is editable
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
            enabled: isEditable, // Control if the field is editable or not
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              suffixIcon: isEditable
                  ? const Icon(Icons.edit_outlined)
                  : null, // Show icon only if editable
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
