/*

AUTH GATE - This will continuously listen for auth state changes

----------------------------------------------------------------

unauthenticated -> Login Page
authenticated -> Profile Page

*/

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pcs_11/pages/main_profile/login_page.dart';
import 'package:pcs_11/pages/main_profile/profile_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to auth state shanges
      stream: Supabase.instance.client.auth.onAuthStateChange, 

      // Build appropriate page based on auth state
      builder: (context, snapshot) {
        // loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }

        // Check if there is a valid session currently
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const ProfilePage();
        }
        else {
          return const LoginPage();
        }
      },
    );
  }
}
