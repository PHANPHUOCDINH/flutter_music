import 'package:flutter/material.dart';

import '../../source.dart';

class WidgetDialogConfirm extends StatelessWidget {
  final String title;
  final String content;

  final Function actionCancel;
  final Function actionConfirm;

  const WidgetDialogConfirm({
    @required this.title,
    @required this.content,
    this.actionCancel,
    this.actionConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              content,
              style: AppStyles.DEFAULT_MEDIUM,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 1),
              Expanded(
                child: Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                      ),
                      onTap: actionCancel ?? () => Navigator.pop(context, false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        height: 45,
                        child: Center(
                          child: Text(
                            "Huỷ bỏ",
                            style: AppStyles.DEFAULT_MEDIUM_BOLD.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                  ],
                ),
              ),
              const SizedBox(width: 1),
              Expanded(
                child: Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                      ),
                      onTap: actionConfirm ?? () => Navigator.pop(context, false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16),
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
                    const SizedBox(height: 1),
                  ],
                ),
              ),
              const SizedBox(width: 1),
            ],
          ),
        ],
      ),
    );
  }
}
