import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import 'practice_app_bar.dart';
import 'practice_side_menu.dart';

class PracticeScaffold extends StatefulWidget {
  final bool isRoot;
  final Widget body;
  final Color backgroundColor;
  final VoidCallback? onBack;

  const PracticeScaffold({
    super.key,
    required this.isRoot,
    required this.body,
    this.backgroundColor = AppColors.white,
    this.onBack,
  });

  @override
  State<PracticeScaffold> createState() => _PracticeScaffoldState();
}

class _PracticeScaffoldState extends State<PracticeScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openSideMenu() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else if (Navigator.of(context).canPop()) {
      Get.back();
    } else {
      Get.offNamed(AppRoute.startStep5Score);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget.backgroundColor,
      drawer: const PracticeSideMenu(),
      appBar: PracticeAppBar(
        isRoot: widget.isRoot,
        onBackTap: _handleBack,
        onMenuTap: _openSideMenu,
      ),
      body: widget.body,
    );
  }
}
