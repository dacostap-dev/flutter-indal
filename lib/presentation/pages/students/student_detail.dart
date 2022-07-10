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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student.name),
      ),
      body: Consumer(
        builder: (context, ref, widget) {
          final state = ref.watch(modulCubit);

          if (state is ModulLoadFailed) {
            return const Center(child: Text('Error'));
          }

          if (state is ModulLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 12,
              itemBuilder: (context, index) => const ModulSkeleton(),
            );
          }

          if (state is ModulLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: state.moduls.length,
              itemBuilder: (context, index) => ModulItem(
                modul: state.moduls[index],
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
            builder: (_) => const CreateModul(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateModul extends ConsumerStatefulWidget {
  const CreateModul({
    Key? key,
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
                    studentId: 'studentId',
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
