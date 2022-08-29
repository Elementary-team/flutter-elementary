import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_elementary_test/redux/store/dogs_state.dart';
import 'package:redux_elementary_test/services/client.dart';
import 'package:redux_elementary_test/shared_pref_helper.dart';
import 'package:redux_epics/redux_epics.dart';

import 'redux/control/dog_data_epics_middleware.dart';
import 'redux/control/dog_data_reducers.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => Dio(),
        ),
        Provider<SharedPrefHelper>(
          create: (_) => SharedPrefHelper(),
        ),
        Provider<Store<DogsState>>(
            create: (context) => Store<DogsState>(
                  combineReducers<DogsState>([
                    DogDataReducers.getReducers,
                  ]),
                  initialState: const DogsState(),
                  distinct: true,
                  middleware: [
                    EpicMiddleware(
                      DogDataEpicMiddleware(
                        Client(context.read<Dio>()),
                        context.read<SharedPrefHelper>(),
                      ).getEffects(),
                    )
                  ],
                )),
      ],
      child: child,
    );
  }
}
