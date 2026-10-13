import 'package:flutter/material.dart';
import '../../../../core/utils/constants/colors.dart';
import 'practice_app_bar.dart';
import 'practice_side_menu.dart';

class PracticeScaffold extends StatefulWidget {
  final bool isRoot;
  final Widget body;
  final Color backgroundColor;

  const PracticeScaffold({
    super.key,
    required this.isRoot,
    required this.body,
    this.backgroundColor = AppColors.white,
  });

  @override
  State<PracticeScaffold> createState() => _PracticeScaffoldState();
}

class _PracticeScaffoldState extends State<PracticeScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openSideMenu() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget.backgroundColor,
      drawer: const PracticeSideMenu(),
      appBar: PracticeAppBar(
        isRoot: widget.isRoot,
        onLeadingTap: widget.isRoot ? _openSideMenu : null,
        onProfileTap: _openSideMenu,
      ),
      body: widget.body,
    );
  }
}
