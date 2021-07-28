import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'bolc_event.dart';

part 'bolc_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(InitialTestState());

  static TestBloc get(context) => BlocProvider.of(context);
  @override
  Stream<TestState> mapEventToState(TestEvent event) async* {
    // TODO: Add your event logic
  }
}
