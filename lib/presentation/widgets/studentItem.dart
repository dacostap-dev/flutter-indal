import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:indal/domain/models/Student.dart';
import 'package:indal/presentation/notifiers/student/student_notifier.dart';
import 'package:skeleton_text/skeleton_text.dart';

class StudentItem extends ConsumerWidget {
  final Student student;
  final VoidCallback onTap;

  const StudentItem({
    Key? key,
    required this.student,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(student.id),
      onDismissed: (direction) => print(student.id),
      child: ListTile(
        onTap: onTap,
        title: Text(student.name),
        subtitle: Text(student.email),
        leading: const Icon(
          Icons.account_circle,
          size: 32,
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                constraints: const BoxConstraints(),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => UpdateStudentDialog(student: student),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                constraints: const BoxConstraints(),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Eliminar Promoción'),
                      titleTextStyle: Theme.of(context).textTheme.titleMedium,
                      content: Text(
                        '¿Estás seguro que quieres eliminar al alumno ${student.name}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => {
                            ref
                                .read(studentCubit.notifier)
                                .deleteStudent(student),
                            Navigator.pop(context)
                          },
                          child: const Text('Aceptar'),
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentSkeleton extends StatelessWidget {
  const StudentSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SkeletonAnimation(
          shimmerColor: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          shimmerDuration: 1000,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonAnimation(
                  shimmerColor: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  shimmerDuration: 1000,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SkeletonAnimation(
                  shimmerColor: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(50),
                  shimmerDuration: 1000,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class UpdateStudentDialog extends ConsumerStatefulWidget {
  final Student student;

  const UpdateStudentDialog({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  UpdateStudentDialogState createState() => UpdateStudentDialogState();
}

class UpdateStudentDialogState extends ConsumerState<UpdateStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();

  late Student studentEdit;

  @override
  void initState() {
    // TODO: implement initState

    _nameController.text = widget.student.name;
    _emailController.text = widget.student.email;
    _genderController.text = widget.student.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Editar Promoción'),
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
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
              studentEdit = widget.student.copyWith(
                name: _nameController.text,
                email: _emailController.text,
                gender: _genderController.text,
              );

              ref
                  .read(studentCubit.notifier)
                  .updateStudent(student: studentEdit);

              Navigator.pop(context);
            }
          },
          child: const Text('Guardar'),
        )
      ],
    );
  }
}
