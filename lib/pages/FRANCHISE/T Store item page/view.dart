import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/T%20Store%20item%20page/controller.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/order%20success%20Page/view.dart';
import 'package:tssr_ctrl/routes/names.dart';

class TStoreItemPage extends GetView<TStoreItemPageController> {
  TStoreItemPage({super.key});

  final doc = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      bool isMobile = Get.width <= 768 ? true : false;
      return Scaffold(
        extendBody: true,
        body: SafeArea(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              SizedBox(
                height: Get.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        height: isMobile ? Get.width : Get.width / 4,
                        width: isMobile ? Get.width : Get.width / 4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/book.png'),
                          ),
                        ),
                        child: isMobile?Align(
                          alignment: Alignment.topLeft,
                          child: ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fixedSize: Size(100, 50)),
                            child: Icon(Icons.arrow_back_sharp),
                          ),
                        ):null,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.6,
                                  child: Text(
                                    doc['name'],
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  '₹ ${doc['price']}',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              doc['course'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Quantity :',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () =>
                                      controller.decreamentQuantity(),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorConstants.blachish_clr,
                                      elevation: 0,
                                      fixedSize: Size(50, 50),
                                      shape: CircleBorder()),
                                  child: Icon(Icons.remove),
                                ),
                                SizedBox(
                                    width: 70,
                                    child: TextFormField(
                                      showCursor: false,
                                      controller: controller.state.quantity,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorConstants.blachish_clr,
                                          fontSize: 30),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        controller.onQuantitiyChanges();
                                      },
                                    )),
                                ElevatedButton(
                                  onPressed: () =>
                                      controller.increamentQuantity(),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      fixedSize: Size(50, 50),
                                      shape: CircleBorder(),
                                      side: BorderSide(
                                          color: ColorConstants.blachish_clr,
                                          width: 2)),
                                  child: Icon(Icons.add,
                                      color: ColorConstants.blachish_clr),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Text(
                              doc['desc'],
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height,
                child: Column(
                  children: [
                    Spacer(),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 80,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: ColorConstants.blachish_clr,
                          borderRadius: BorderRadius.circular(40)),
                      child: Obx(() {
                        return Row(
                          children: [
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Grand Total',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Obx(() {
                                  return Text(
                                    '₹ ${controller.state.total.value}',
                                    // '₹ ${double.parse(doc['price'])*int.parse(controller.state.quantity.text)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                    ),
                                  );
                                }),
                              ],
                            ),
                            Spacer(),
                            controller.state.isLoading.value
                                ? SizedBox(
                                    width: 180,
                                    height: 60,
                                    child: Center(
                                      child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () async =>
                                        await controller.placeOrder(),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor:
                                            ColorConstants.blachish_clr,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        fixedSize: Size(180, 60)),
                                    child: Text(
                                      'Buy Now',
                                      style: TextStyle(
                                        color: ColorConstants.blachish_clr,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
