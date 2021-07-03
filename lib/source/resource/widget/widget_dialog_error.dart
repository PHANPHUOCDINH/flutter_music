import 'package:flutter/material.dart';

import '../../source.dart';

class WidgetDialogError extends StatelessWidget {
  final String title;

  final Function onAction;

  const WidgetDialogError({
    @required this.title,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        elevation: 8,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 26),
        backgroundColor: HexColor.fromHex("#fdfefe"),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                title,
                style: AppStyles.DEFAULT_MEDIUM,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 18),
            InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
              ),
              onTap: onAction ?? () => Navigator.pop(context, false),
              child: Row(
                children: [
                  const SizedBox(width: 0.75),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      height: 45,
                      child: Center(
                        child: Text(
                          "OK",
                          style: AppStyles.DEFAULT_MEDIUM_BOLD.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 0.75),
                ],
              ),
            ),
            const SizedBox(height: 0.75),
          ],
        ),
      ),
    );
  }
}
