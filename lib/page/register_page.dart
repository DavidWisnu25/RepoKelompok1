import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ugd_bloc/bloc/form_submission_state.dart';
import 'package:ugd_bloc/bloc/register_bloc.dart';
import 'package:ugd_bloc/bloc/register_event.dart';
import 'package:ugd_bloc/bloc/register_state.dart';
import 'package:ugd_bloc/page/login_page.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterviewState();
}

class _RegisterviewState extends State<RegisterView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool isPasswordVisible = false;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.formSubmissionState is SubmissionSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginView(),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Register Success'),
              ),
            );
          }
          if (state.formSubmissionState is SubmissionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text((state.formSubmissionState as SubmissionFailed)
                    .exception
                    .toString()),
              ),
            );
          }
        },
        child:
            BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Username',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your username';
                          } else if (value.length < 4 ) {
                            return 'Username minimal 4 huruf';
                          }
                          return null;
                        }
                      ),
                      TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            } else if (!value.contains('@')) {
                              return 'Email must contain the "@" symbol';
                            }
                            return null;
                          }),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              context.read<RegisterBloc>().add(
                                    IsPasswordVisibleChanged(),
                                  );
                            },
                            icon: Icon(
                              state.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: state.isPasswordVisible
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        obscureText: !state.isPasswordVisible,
                        validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 5) {
                              return 'Password minimal 5 huruf';
                            }
                            return null;
                          }
                      ),
                      TextFormField(
                        controller: genderController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.transgender),
                          labelText: 'Gender',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your gender';
                          } else if (value != "L" && value != "P") {
                            return 'Gender harus diisi dengan L atau P';
                          }
                          return null;
                        }
                      ),
                      TextFormField(
                        keyboardType:
                            TextInputType.number, // Set keyboard type to number
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Phone Number',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (value.length != 12) {
                            return 'Phone number must have exactly 12 digits';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          // Parse the input text as an integer and assign it to noTelpon
                          context
                              .read<RegisterBloc>()
                              .add(NoTelponChanged(int.tryParse(value) ?? 0));
                        },
                      ),
                      TextFormField(
                        controller: dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                            labelText: 'Born Date',
                            prefixIcon: Icon(Icons.date_range),
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.blue,
                            )),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            if (pickedDate.isAfter(DateTime.now())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Born Date cannot be in the future.'),
                                ),
                              );
                            } else {
                              selectedDate = pickedDate;
                              dateController.text = selectedDate.toLocal().toString().split(' ')[0];
                            }
                          }
                        },
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter your born date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<RegisterBloc>().add(
                                    FormSubmitted(
                                      username: usernameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      gender: genderController.text,
                                      noTelpon: 0,
                                      selectedDate: DateTime.now(),
                                    ),
                                  );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            child: state.formSubmissionState is FormSubmitting
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("Register"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
