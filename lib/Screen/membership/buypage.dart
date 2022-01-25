import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pricing_cards/pricing_cards.dart';
import 'package:wrtappv2/const/abstract.dart';

class BuyPage extends StatelessWidget {
  const BuyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _konst = Get.find<Konst>();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
                child: PricingCards(
              pricingCards: [
                PricingCard(
                  title: 'Basic',
                  price: 'Rp 200',
                  subPriceText: '/Minggu',
                  billedText: '',
                  cardColor: Colors.blue,
                  onPress: () async {
                    _konst.topUpAmount.value = 1;
                    _konst.bayar(1);
                  },
                ),
                PricingCard(
                  title: 'Pro',
                  price: 'Rp 500',
                  subPriceText: '/Bulan',
                  billedText: '',
                  cardColor: Colors.green,
                  mainPricing: true,
                  mainPricingHighlightText: 'Save money',
                  onPress: () async {
                    _konst.topUpAmount.value = 1;
                    _konst.bayar(1);
                  },
                ),
                PricingCard(
                  title: 'Premium',
                  price: 'Rp 600',
                  subPriceText: '/3 Bulan',
                  billedText: '',
                  cardColor: Colors.red,
                  onPress: () async {
                    _konst.topUpAmount.value = 1;
                    _konst.bayar(1);
                  },
                ),
              ],
            )),
          ),
          const SizedBox(height: 30),
          const Text("Metode Pembayaran yang Didukung"),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.credit_card),
                onPressed: () {
                  // make your business
                },
              ),
              IconButton(
                icon: const Icon(MdiIcons.abugidaThai),
                onPressed: () {
                  // make your business
                },
              ),
              IconButton(
                icon: const Icon(Icons.monetization_on),
                onPressed: () {
                  // make your business
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
