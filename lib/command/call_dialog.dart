import 'package:flutter/material.dart';

class CallDialog {
  /// 审核通过与拒绝弹框
  static void show({
    required BuildContext context,
    required String title,
    Color? titleColor,
    required String content,
    String? cancelText,
    String? confirmText,
    void Function()? onCancel,
    void Function()? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                color: Colors.white,
                width: 260,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: titleColor ?? Color(0xFF333333),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        content,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        SizedBox(width: 12),
                        _buildButtonItem(
                          context: context,
                          title: cancelText ?? "",
                          backgroudColor:
                              Theme.of(context).primaryColor.withAlpha(25),
                          textColor: Theme.of(context).primaryColor,
                          onConfirm: () {
                            // Navigator.of(context).pop();
                            onCancel?.call();
                          },
                        ),
                        SizedBox(width: 12),
                        Visibility(
                          visible: confirmText != null,
                          child: _buildButtonItem(
                            context: context,
                            title: confirmText ?? "",
                            backgroudColor: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onConfirm: onConfirm,
                          ),
                        ),
                        Visibility(
                          visible: confirmText != null,
                          child: SizedBox(width: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildButtonItem({
    required BuildContext context,
    required String title,
    required Color backgroudColor,
    required Color textColor,
    double height = 38,
    void Function()? onConfirm,
    double radius = 19,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: backgroudColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Container(
              height: height,
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(color: textColor, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
