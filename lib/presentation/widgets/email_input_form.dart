// lib/presentation/widgets/email_input_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/airport_bloc/airport_bloc.dart';
import '../blocs/airport_bloc/airport_event.dart';

class EmailInputForm extends StatefulWidget {
  const EmailInputForm({Key? key}) : super(key: key);

  @override
  _EmailInputFormState createState() => _EmailInputFormState();
}

class _EmailInputFormState extends State<EmailInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.alternate_email, color: Color(0xFF7B1FA2)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF7B1FA2), width: 1.2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF7B1FA2), width: 1.2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7B1FA2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AirportBloc>().add(
                        GetAirportsByEmailDomainEvent(_emailController.text),
                      );
                }
              },
              icon: Icon(Icons.search, color: Colors.white),
              label: Text('Get Airports', style: TextStyle(fontSize: 17)),
            ),
          ),
        ],
      ),
    );
  }
}
