// Mocks generated by Mockito 5.4.4 from annotations
// in nova_chrono/test/mocks/annotations.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i3;
import 'package:nova_chrono/application/api/task_create_service.dart' as _i6;
import 'package:nova_chrono/application/api/task_delete_service.dart' as _i9;
import 'package:nova_chrono/application/api/task_edit_service.dart' as _i8;
import 'package:nova_chrono/application/api/task_list_service.dart' as _i7;
import 'package:nova_chrono/domain/model/task.dart' as _i5;
import 'package:nova_chrono/domain/repository/task_repository.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [TaskRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockTaskRepository extends _i1.Mock implements _i2.TaskRepository {
  MockTaskRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String nextIdentity() => (super.noSuchMethod(
        Invocation.method(
          #nextIdentity,
          [],
        ),
        returnValue: _i3.dummyValue<String>(
          this,
          Invocation.method(
            #nextIdentity,
            [],
          ),
        ),
      ) as String);

  @override
  _i4.Future<void> add(_i5.Task? task) => (super.noSuchMethod(
        Invocation.method(
          #add,
          [task],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<_i5.Task?> getById(String? taskId) => (super.noSuchMethod(
        Invocation.method(
          #getById,
          [taskId],
        ),
        returnValue: _i4.Future<_i5.Task?>.value(),
      ) as _i4.Future<_i5.Task?>);

  @override
  _i4.Future<List<_i5.Task>> getByDate(DateTime? date) => (super.noSuchMethod(
        Invocation.method(
          #getByDate,
          [date],
        ),
        returnValue: _i4.Future<List<_i5.Task>>.value(<_i5.Task>[]),
      ) as _i4.Future<List<_i5.Task>>);

  @override
  _i4.Future<void> updateTask(_i5.Task? task) => (super.noSuchMethod(
        Invocation.method(
          #updateTask,
          [task],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> deleteTask(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteTask,
          [id],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [TaskCreateService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTaskCreateService extends _i1.Mock implements _i6.TaskCreateService {
  MockTaskCreateService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void createTask(
    String? taskName,
    DateTime? startTimestamp,
    DateTime? endTimestamp,
    String? details,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #createTask,
          [
            taskName,
            startTimestamp,
            endTimestamp,
            details,
          ],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [TaskListService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTaskListService extends _i1.Mock implements _i7.TaskListService {
  MockTaskListService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i5.Task>> getTasksByDate(DateTime? date) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTasksByDate,
          [date],
        ),
        returnValue: _i4.Future<List<_i5.Task>>.value(<_i5.Task>[]),
      ) as _i4.Future<List<_i5.Task>>);
}

/// A class which mocks [TaskEditService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTaskEditService extends _i1.Mock implements _i8.TaskEditService {
  MockTaskEditService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void editTask(
    String? taskId,
    String? taskName,
    DateTime? startTimestamp,
    DateTime? endTimestamp,
    String? details,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #editTask,
          [
            taskId,
            taskName,
            startTimestamp,
            endTimestamp,
            details,
          ],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [TaskDeleteService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTaskDeleteService extends _i1.Mock implements _i9.TaskDeleteService {
  MockTaskDeleteService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> deleteTask(String? taskId) => (super.noSuchMethod(
        Invocation.method(
          #deleteTask,
          [taskId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
