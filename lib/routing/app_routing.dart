import 'package:go_router/go_router.dart';
import 'package:web_corp/root/root_screen.dart';
import 'package:web_corp/ui/screens/cabinet_status_screen.dart';
import 'package:web_corp/ui/screens/calendar_screen.dart';
import 'package:web_corp/ui/screens/employee_screen.dart';
import 'package:web_corp/ui/screens/day_detail_screen.dart';

final router = GoRouter(
  initialLocation: '/cabinet',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          RootScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/calendar',
              builder: (context, state) => const CalendarScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/employee',
              builder: (context, state) => const EmployeeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cabinet',
              builder: (context, state) => const CabinetStatusScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/day/:date',
      builder: (context, state) {
        final dateStr = state.pathParameters['date']!;
        final parts = dateStr.split('-');
        final date = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        return DayDetailScreen(selectedDate: date);
      },
    )
  ],
);