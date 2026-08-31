import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/setup_screen.dart';
import '../screens/pass_phone_screen.dart';
import '../screens/role_reveal_screen.dart';
import '../screens/question_round_screen.dart';
import '../screens/guesser_screen.dart';
import '../screens/word_reveal_screen.dart';
import '../screens/discussion_screen.dart';
import '../screens/voting_screen.dart';
import '../screens/result_screen.dart';
import '../screens/scoreboard_screen.dart';
import '../screens/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/setup',
      builder: (context, state) => const SetupScreen(),
    ),
    GoRoute(
      path: '/pass_phone',
      builder: (context, state) => const PassPhoneScreen(),
    ),
    GoRoute(
      path: '/role_reveal',
      builder: (context, state) => const RoleRevealScreen(),
    ),
    GoRoute(
      path: '/question_round',
      builder: (context, state) => const QuestionRoundScreen(),
    ),
    GoRoute(
      path: '/guesser',
      builder: (context, state) => const GuesserScreen(),
    ),
    GoRoute(
      path: '/word_reveal',
      builder: (context, state) => const WordRevealScreen(),
    ),
    GoRoute(
      path: '/discussion',
      builder: (context, state) => const DiscussionScreen(),
    ),
    GoRoute(
      path: '/voting',
      builder: (context, state) => const VotingScreen(),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) => const ResultScreen(),
    ),
    GoRoute(
      path: '/scoreboard',
      builder: (context, state) => const ScoreboardScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
