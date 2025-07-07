import 'package:flutter/material.dart';
import 'edit_profile_card.dart'; 
import 'change_password.dart';

class EditProfileButton extends StatelessWidget {
  final VoidCallback onEdited;

  const EditProfileButton({Key? key, required this.onEdited}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E5F8A),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 14),
              ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfileCard()),
            ).then((_) => onEdited()); // actualiza HomePage al volver
          },
          icon: const Icon(Icons.edit, color: Colors.white),
          label: const Text('Edit profile', style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
           style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E5F8A),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 14),
              ),
                
          
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
            );
          },
          icon: const Icon(Icons.lock_reset, color: Colors.white),
          label: const Text('Change password', style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }
}
