import 'package:ezy_member/globals.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: SizedBox(
          height: logoSize,
          child: Image(
            image: AssetImage('assets/$logoName'),
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.myPrimaryColor,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        width: double.infinity,
        color: ColorConstants.myPrimaryColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15),
          child: ListView(
            children: [
              Text(
                  "About Us".tr,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )
              ),
              const SizedBox(height: 10,),
              const Text(
                "公司名称 : 老字号神料佛具一站式中心",
                maxLines: 15,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    height: 2
                ),
              ),
              const Text(
                "成立时间 : 2012年",
                maxLines: 15,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    height: 2
                ),
              ),
              const Text(
                "公司类型 : 零售与批发",
                maxLines: 15,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    height: 2
                ),
              ),
              const Text(
                "核心业务 : 神料、佛具产品一站式销售",
                maxLines: 15,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    height: 2
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "公司简介",
                maxLines: 15,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 2
                ),
              ),
              const Text(
                "老字号神料佛具一站式中心自2012年成立以来，一直致力于传承与弘扬传统神料文化。"
                    "我们直接与来自中国、台湾、越南、印尼等地的优质制造商合作，确保产品以第一手价钱和高品质供应给顾客。"
                    "通过这种直销模式，我们不仅降低了中间环节的成本，还能严格把控产品的质量，为顾客提供种类齐全、品质优良的神料和佛具。",
                maxLines: 15,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    height: 2
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "我们坚持薄利多销的经营理念，提供多样化的产品选择，涵盖传统神料、佛具以及结合现代元素的创新产品，"
                    "以满足不同客户的需求。目前公司已在多个住宅花园设有四间分店，并拥有两间货仓的销售和服务。",
                maxLines: 15,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    height: 2
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "在运营管理方面，公司将继续优化供应链，提升管理效率，并通过数据分析精准把握市场需求。"
                    "未来，我们还将积极寻求外部投资，强化财务管理，力争在保持薄利多销策略的同时，实现长期稳步增长。",
                maxLines: 15,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    height: 2
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "公司愿景",
                maxLines: 15,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 2
                ),
              ),
              const Text(
                "老字号神料佛具一站式中心将继续秉持谦虚和创新精神，致力于为顾客提供多样化、高品质的产品，推动传统文化融入现代生活，携手共创美好未来。",
                maxLines: 15,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    height: 2
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
