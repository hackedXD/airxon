import 'package:ac/colors.dart';
import 'package:ac/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("BeAwair", style: TextStyles.title2.copyWith(fontSize: 18)),
          ],
        ),
        const Gap(7),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                  "BeAwair was made for the Junior Achievement Competition by 17 students from Singapore American School.\nBeAwair is a cost and eco-friendly way to monitor air con consumption. Through the device, which is easily attached onto the side of an air con, the user can track data that is filtered onto the BeAwair application. Through this product, users are able to immerse themselves into sustainable living and invest into green technology that gives back to the earth. BeAwair’s application is designed to be user friendly which provides customers the ability to set tangible goals to reduce personal energy consumption. All of these steps help you as consumers contribute to the UN Sustainable Goals 2030.",
                  style: TextStyles.base),
            )),
        const Gap(5),
        // Divider(
        //   color: colors.main.overlay2,
        // ),
        // const Gap(5),
        // Center(
        //   child: Text("Development: Person",
        //       style: TextStyles.title2.copyWith(fontSize: 15)),
        // ),
        // const Gap(5),
        // Center(
        //   child: Text("Project Creation: Person",
        //       style: TextStyles.title2.copyWith(fontSize: 15)),
        // ),
        // const Gap(5),
        // Center(
        //   child: Text("Company Management: Person",
        //       style: TextStyles.title2.copyWith(fontSize: 15)),
        // ),
      ],
    ));
  }
}
