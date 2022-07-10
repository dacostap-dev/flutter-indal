import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/presentation/notifiers/student/student_notifier.dart';
import 'package:indal/presentation/pages/promotions/promotion_detail.dart';
import 'package:indal/presentation/widgets/studentItem.dart';

class StudentsPage extends ConsumerStatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  StudentsPageState createState() => StudentsPageState();
}

class StudentsPageState extends ConsumerState<StudentsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studentCubit.notifier).getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alumnos'),
      ),
      body: Consumer(
        builder: (context, ref, widget) {
          final state = ref.watch(studentCubit);

          if (state is StudentLoadFailed) {
            return const Center(child: Text('Error'));
          }

          if (state is StudentLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 12,
              itemBuilder: (context, index) => const StudentSkeleton(),
            );
          }

          if (state is StudentLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: state.students.length,
              itemBuilder: (context, index) => StudentItem(
                student: state.students[index],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const CreateStudent(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateStudent extends ConsumerStatefulWidget {
  const CreateStudent({
    Key? key,
  }) : super(key: key);

  @override
  CreateStudentState createState() => CreateStudentState();
}

class CreateStudentState extends ConsumerState<CreateStudent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(20),
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                validator: (text) {
                  if (text == '') {
                    return 'Ingrese el nombre del alumno';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text(
                    'Nombre',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text == '') {
                    return 'Ingrese el email del alumno';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text(
                    'Email',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _genderController,
                validator: (text) {
                  if (text == '') {
                    return 'Ingrese el genero del alumno';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text(
                    'Genero',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ref.read(studentCubit.notifier).addStudent(
                    name: _nameController.text,
                    email: _emailController.text,
                    gender: _genderController.text,
                    promocionId: 'promocionId',
                  );

              Navigator.pop(context);
            }
          },
          child: const Text('Guardar'),
        )
      ],
    );
  }
}
