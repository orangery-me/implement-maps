import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/widgets/common_rounded_button.dart';
import 'package:flutter_template/router/app_router.dart';

class MapSearchButtonWidget extends StatelessWidget {
  const MapSearchButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: CommonRoundedButton(
          width: double.infinity,
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.locationList);
          },
          backgroundColor: Colors.white,
          content: 'Search Location',
          borderRadius: 15,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
