import 'package:flutter/material.dart';
import '../login_view/presentation/pages/login_screen.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  UserSelectionScreenState createState() => UserSelectionScreenState();
}

class UserSelectionScreenState extends State<UserSelectionScreen> {
  String selectedUserType = 'client';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F0EC),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Are you a seller or a client?',
              style: TextStyle(
                fontFamily: "Roboto",
                color: Color(0xff0E0705),
                fontSize: 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Color(0xff9D9896),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal),
                        '         Choose the method that aligns with the\n                          service you want.')),
              ],
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildUserTypeCard(
                    bc: const Color(0xffEDD3CA),
                    'client',
                    'assets/images/3.0x/Group_3.0x.png'),
                const SizedBox(width: 10),
                _buildUserTypeCard(
                    bc: const Color(0xffDDDAD9),
                    'seller',
                    'assets/images/3.0x/Character_3.0x.png'),
              ],
            ),
            const SizedBox(height: 100),
            //Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff8C4931),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'continue',
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffEEEDEC)),
                ),
              ),
            ),
            //SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeCard(String type, String imagePath,
      {required Color bc}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUserType = type;
        });
      },
      child: Container(
        width: 155,
        height: 210,
        //padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        decoration: BoxDecoration(
          color: bc,
          // color: selectedUserType == type
          //     ? Colors.brown.shade600
          //     : Color(0xffDDDAD9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  child: Radio<String>(
                    value: type,
                    groupValue: selectedUserType,
                    onChanged: (value) {
                      setState(() {
                        selectedUserType = value!;
                      });
                    },
                    activeColor: const Color(0xff8C4931),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45.0, left: 7),
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff0E0705),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(imagePath, height: 175),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../login_view/presentation/pages/login_screen.dart';
//
// class UserSelectionScreen extends StatefulWidget {
//   const UserSelectionScreen({super.key});
//
//   @override
//   UserSelectionScreenState createState() => UserSelectionScreenState();
// }
//
// class UserSelectionScreenState extends State<UserSelectionScreen> {
//   String selectedUserType = 'client';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F0EC),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               'Are you a seller or a client?',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//                 'Choose the method that aligns with the service you want.'),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildUserTypeCard(
//                     'client', 'assets/images/1.0x/Group_1.0x.png'),
//                 const SizedBox(width: 10),
//                 _buildUserTypeCard(
//                     'seller', 'assets/images/1.0x/Character_1.0x.png'),
//               ],
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF8C4931),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//               ),
//               child: const Text(
//                 'Continue',
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserTypeCard(String type, String imagePath) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedUserType = type;
//         });
//       },
//       child: Container(
//         width: 120,
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: selectedUserType == type
//               ? Colors.brown.shade200
//               : Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             Image.asset(imagePath, height: 50),
//             const SizedBox(height: 10),
//             Text(
//               type.toUpperCase(),
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
