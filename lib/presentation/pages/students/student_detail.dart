import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Student.dart';
import 'package:indal/presentation/notifiers/modul/modul_notifier.dart';

import 'package:indal/presentation/widgets/modulItem.dart';

class StudentDetail extends ConsumerStatefulWidget {
  final Student student;

  const StudentDetail({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  StudentDetailState createState() => StudentDetailState();
}

class StudentDetailState extends ConsumerState<StudentDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(modulCubit.notifier).getModulsByStudent(widget.student.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(errorProvider, (previous, next) {
      print('listen');
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.student.name} (Módulos)'),
      ),
      body: Consumer(
        builder: (context, ref, widget) {
          final state = ref.watch(modulCubit);

          print(state.toString());

          return state.when(
            data: (data) {
              if (data.isEmpty) {
                return const Center(child: Text('No tiene Modulos'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) => ModulItem(
                  modul: data[index],
                ),
              );
            },
            error: (err, st) => const Center(child: Text('Error')),
            loading: () => GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 6,
              itemBuilder: (context, index) => const ModulSkeleton(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateModul(studentId: widget.student.id),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateModul extends ConsumerStatefulWidget {
  final String studentId;

  const CreateModul({
    Key? key,
    required this.studentId,
  }) : super(key: key);

  @override
  CreateModulState createState() => CreateModulState();
}

class CreateModulState extends ConsumerState<CreateModul> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _informeController = TextEditingController();
  final _memorandumController = TextEditingController();
  final _solicitudController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _informeController.dispose();
    _memorandumController.dispose();
    _solicitudController.dispose();
    super.dispose();
  }

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
                decoration: const InputDecoration(
                  label: Text(
                    'Nombre',
                  ),
                ),
                validator: (text) {
                  if (text == '') {
                    return 'Ingrese el nombre del modulo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _informeController,
                decoration: const InputDecoration(
                  label: Text(
                    'Informe',
                  ),
                ),
                validator: (text) {
                  if (text == '') {
                    return 'Ingrese el informe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _memorandumController,
                decoration: const InputDecoration(
                  label: Text(
                    'Memorandum',
                  ),
                ),
                validator: (text) {
                  if (text == '') {
                    return 'Ingrese el memorandum';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _solicitudController,
                decoration: const InputDecoration(
                  label: Text(
                    'Solicitud',
                  ),
                ),
                validator: (text) {
                  if (text == '') {
                    return 'Ingrese la solicitud';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ref.read(modulCubit.notifier).addModul(
                    name: _nameController.text,
                    studentId: widget.studentId,
                    informe: _informeController.text,
                    memorandum: _memorandumController.text,
                    solicitud: _solicitudController.text,
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
