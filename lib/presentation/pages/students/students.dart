import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:indal/domain/models/Student.dart';
import 'package:indal/presentation/notifiers/student/student_notifier.dart';
import 'package:indal/presentation/widgets/studentItem.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StudentsPage extends ConsumerStatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  StudentsPageState createState() => StudentsPageState();
}

class StudentsPageState extends ConsumerState<StudentsPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studentCubit.notifier).getStudents();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Student>>>(studentCubit, (previous, next) {
      //null cuando esta en loading or error
      if (next.asData != null) {
        _refreshController.loadComplete();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alumnos'),
        actions: <Widget>[
          PopupMenuButton<StudentQuery>(
            onSelected: (value) async {
              ref.read(filterStudentProvider.notifier).state = value;

              ref.read(studentCubit.notifier).clearStudents();
              ref.read(studentCubit.notifier).getStudents();
            },
            icon: const Icon(Icons.sort),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: StudentQuery.name,
                  child: Text('Sort by Name'),
                ),
                const PopupMenuItem(
                  value: StudentQuery.createdAt,
                  child: Text('Sort by CreatedAt'),
                ),
              ];
            },
          )
        ],
      ),
      body: Consumer(
        builder: (context, ref, widget) {
          final state = ref.watch(studentCubit);

          return state.when(
            data: (data) {
              if (data.isEmpty) {
                return const Center(child: Text('No tiene Alumnos'));
              }

              return SmartRefresher(
                enablePullUp: true,
                enablePullDown: false,
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    Widget body;
                    if (mode == LoadStatus.loading) {
                      body = const CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = const Text("Algo salió mal");
                    } else if (mode == LoadStatus.canLoading) {
                      body = const Text("Cargar más alumnos");
                    } else {
                      body = const Text("No hay más alumnos");
                    }
                    return SizedBox(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: _refreshController,
                onLoading: () {
                  ref.read(studentCubit.notifier).getStudents(
                        offset: data.length,
                        lastStudent: data.last,
                      );
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: data.length,
                  itemBuilder: (context, index) => StudentItem(
                    student: data[index],
                    onTap: () {
                      context.pushNamed('student-detail', params: {
                        'studentId': data[index].id,
                      });
                    },
                  ),
                ),
              );
            },
            error: (err, st) => const Center(child: Text('Error')),
            loading: () => ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 12,
              itemBuilder: (context, index) => const StudentSkeleton(),
            ),
          );

          /*       if (state is StudentLoadFailed) {
            return const Center(child: Text('Error'));
          }

          if (state is StudentLoaded) {
            if (state.students.isEmpty) {
              return const Center(child: Text('No hay alumnos'));
            }

            return SmartRefresher(
              enablePullUp: true,
              enablePullDown: false,
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body;
                  if (mode == LoadStatus.loading) {
                    body = const CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = const Text("Algo salió mal");
                  } else if (mode == LoadStatus.canLoading) {
                    body = const Text("Cargar más promociones");
                  } else {
                    body = const Text("No hay más promociones");
                  }
                  return SizedBox(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onLoading: () {
                ref.read(studentCubit.notifier).getStudents(
                      offset: state.students.length,
                      lastStudent: state.students.last,
                    );
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(10),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: state.students.length,
                itemBuilder: (context, index) => StudentItem(
                    student: state.students[index],
                    onTap: () {
                      context.pushNamed('student-detail', params: {
                        'studentId': state.students[index].id,
                      });
                    }),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(10),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: 12,
            itemBuilder: (context, index) => const StudentSkeleton(),
          ); */
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _genderController.dispose();

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
                    promotionId: 'promotionId',
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
