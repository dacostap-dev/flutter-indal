import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Modul.dart';
import 'package:indal/presentation/notifiers/modul/modul_notifier.dart';

class ModulDetail extends ConsumerStatefulWidget {
  final Modul modul;

  const ModulDetail({
    Key? key,
    required this.modul,
  }) : super(key: key);

  @override
  ModulDetailState createState() => ModulDetailState();
}

class ModulDetailState extends ConsumerState<ModulDetail> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _informeController = TextEditingController();
  final _memorandumController = TextEditingController();
  final _solicitudController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.modul.name;
    _informeController.text = widget.modul.informe;
    _memorandumController.text = widget.modul.memorandum;
    _solicitudController.text = widget.modul.solicitud;
    super.initState();
  }

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
    ref.listen<ModulState>(modulCubit, (previous, next) {
      if (next is ModulDeleteSuccess) {
        Navigator.pop(context);
      }

      if (next is ModulDeleteFailed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.modul.name),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref.read(modulCubit.notifier).updateModul(
                              modulId: widget.modul.id,
                              name: _nameController.text,
                              informe: _informeController.text,
                              memorandum: _memorandumController.text,
                              solicitud: _solicitudController.text,
                            );

                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(modulCubit.notifier)
                          .deleteModul(modulId: widget.modul.id);

                      Navigator.pop(context);
                    },
                    child: const Text('Eliminar'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
