import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/timer_bloc.dart';
import 'models/ticker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        /// Create a new TimerBloc instance,
        /// which will be used in the rest of subtree widgets
        create: (context) => TimerBloc(ticker: const Ticker()),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                /// context.select only listens to smaller part of a state
                /// In this case, it is duration value
                '${context.select((TimerBloc bloc) => bloc.state.duration)}',
                style: Theme.of(context).textTheme.headline2,
              ),
              const ActionButtons(),

              /// show the name of the state for us better understanding
              Text(
                '${context.select((TimerBloc bloc) => bloc.state)}',
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (state is TimerInitial) ...[
              FloatingActionButton(
                  child: const Icon(Icons.play_arrow),

                  /// changes from current state to TimerStarted state
                  onPressed: () => context
                      .read<TimerBloc>()
                      .add(TimerStarted(state.duration))),
            ] else if (state is TimerRunInProgress) ...[
              FloatingActionButton(
                  child: const Icon(Icons.pause),

                  /// changes from current state to TimerPaused state
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerPaused())),
              FloatingActionButton(
                  child: const Icon(Icons.refresh),

                  /// changes from current state to TimerReset state
                  onPressed: () => context.read<TimerBloc>().add(TimerReset())),
            ] else if (state is TimerRunPause) ...[
              FloatingActionButton(
                  child: const Icon(Icons.play_arrow),

                  /// changes from current state to TimerRunPause state
                  onPressed: () => context
                      .read<TimerBloc>()
                      .add(TimerResumed(state.duration))),
              FloatingActionButton(
                  child: const Icon(Icons.refresh),
                  onPressed: () => context.read<TimerBloc>().add(TimerReset())),
            ] else if (state is TimerRunComplete) ...[
              /// changes from current state to TimerReset state
              FloatingActionButton(
                  child: const Icon(Icons.refresh),
                  onPressed: () => context.read<TimerBloc>().add(TimerReset()))
            ],
          ],
        );
      },
    );
  }
}
