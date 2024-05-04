import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/shared_prefences.dart';
import '../../utils/app_widget.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({Key? key}) : super(key: key);

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  String urlQr = 'https://img.vietqr.io/image/VCB-0311000738303-qr_only.png';
  String? apiQr;
  String? name;
  @override
  void initState() {
    super.initState();
    SharedPreferenceHelper().getUserName().then((value) {
      if (value != null) {
        setState(() {
          name = value;
        });
      }
    });
    setState(() {
      apiQr = '$urlQr?accountName=BUI%20VAN%20HIEU&amount=0&addInfo=ID% ${name}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          // WidgetAppBarMusic(title: 'via_bank'.tr),
          SingleChildScrollView(
                      child: Column(
          children: [
            const SizedBox(height: 18),
            // const WidgetHeaderIcoinNew(),
            const SizedBox(height: 12),
            Column(
              children: [
                SizedBox(
                  width: 216,
                  height: 216,
                  child: CachedNetworkImage(
                    imageUrl: apiQr ?? '',
                  ),
                ),
                const SizedBox(height: 13),
                GestureDetector(
                  onTap: () async {
                    if (apiQr != null) {
                      _downloadImage();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "Lưu mã QR",
                      textAlign: TextAlign.center,
                      style: AppWidget.LightTextFieldStyle()
                          .copyWith(color: Colors.redAccent, height: 0, fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 19),
            const _WidgetBody(),
          ],
                      ),
                    )
        ],
      );
  }

  _downloadImage() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/qr_vc_bank.png';
      if (!await File(path).exists()) {
        await Dio().download(apiQr!, path);
        await GallerySaver.saveImage(path).then((value) {
          if (value ?? false) {
            Fluttertoast.showToast(msg:"Lưu ảnh thành công");
          } else {
            Fluttertoast.showToast(msg: "Lưu ảnh thất bại");
          }
        });
      } else {
        await GallerySaver.saveImage(path).then((value) {
          if (value ?? false) {
            Fluttertoast.showToast(msg:"Lưu ảnh thành công");
          } else {
            Fluttertoast.showToast(msg: "Lưu ảnh thất bại");
          }
        });
      }
    } on DioException catch (_) {
      Fluttertoast.showToast(msg: "Lưu ảnh thất bại");
    }
  }
}

class _WidgetBody extends StatelessWidget {
  const _WidgetBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _WidgetDesBank("Ngân hàng", "Vietcombank"),
          const SizedBox(height: 13),
          const _WidgetDesBank("Tên tài khoản:","BUI VAN HIEU"),
          const SizedBox(height: 13),
          _WidgetDesBank(
            "Số tài khoản:",
            '0311000738303',
            isButton: true,
          ),
          const SizedBox(height: 13),
          _WidgetDesBank(
            "Nội dung chuyển khoản:",
            "Thanh toán tiền hóa đơn ",
            isButton: true,
          ),
        ],
      ),
    );
  }
}

class _WidgetDesBank extends StatelessWidget {
  final String title;
  final String des;
  final bool? isButton;

  const _WidgetDesBank(this.title, this.des, {Key? key, this.isButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        textAlign: TextAlign.left,
                        style: AppWidget.LightTextFieldStyle().copyWith(
                            fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 5),
                    Text(
                      des,
                      textAlign: TextAlign.left,
                      style: AppWidget.LightTextFieldStyle()
                          .copyWith(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isButton ?? false,
                child: GestureDetector(
                  onTap: () {
                    String copyText = des.replaceAll(':', '');
                    Clipboard.setData(ClipboardData(text: copyText));
                    // AppUtils.showToast('toast_copy_clipboard'.tr);
                  },
                  child: Container(
                    width: 110,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "Sao chép",
                      style: AppWidget.LightTextFieldStyle()
                          .copyWith(color: Colors.redAccent, height: 0, fontSize: 14),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 13),
          const _WidgetMySeparator()
        ],
      ),
    );
  }
}

class _WidgetMySeparator extends StatelessWidget {
  const _WidgetMySeparator({Key? key, this.height = 0.5, this.color = Colors.black12})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 3.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
