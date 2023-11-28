import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animo_eats/bloc/food/food_bloc.dart';
import 'package:animo_eats/bloc/order/order_bloc.dart';
import 'package:animo_eats/bloc/theme/theme_bloc.dart';
import 'package:animo_eats/models/food.dart';
import 'package:animo_eats/repositories/order_repository.dart';
import 'package:animo_eats/ui/screens/chat/chat_list_screen.dart';
import 'package:animo_eats/ui/screens/home/profile_screen.dart';
import 'package:animo_eats/ui/screens/order/order_list_screen.dart';
import 'package:animo_eats/ui/widgets/items/food_item.dart';
import 'package:animo_eats/utils/app_colors.dart';
import 'package:animo_eats/utils/app_styles.dart';
import 'package:animo_eats/utils/custom_text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Food> _foods = [];
  final int _foodLimit = 5;

  @override
  void initState() {
    BlocProvider.of<FoodBloc>(context).add(
      LoadFoods(
        limit: _foodLimit,
        lastDocument: null,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide keyboard when user taps outside an input field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              decoration: BoxDecoration(
                color: AppColors().cardColor,
                borderRadius: AppStyles.largeBorderRadius,
                boxShadow: [AppStyles().largeBoxShadow],
              ),
              child: NavigationBar(
                backgroundColor: Colors.transparent,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                selectedIndex: _selectedIndex,
                destinations: [
                  NavigationDestination(
                    icon: Opacity(
                      opacity: 0.5,
                      child: SvgPicture.asset(
                        "assets/svg/home.svg",
                      ),
                    ),
                    selectedIcon: SvgPicture.asset(
                      "assets/svg/home.svg",
                    ),
                    label: "Home",
                  ),
                  NavigationDestination(
                    icon: Opacity(
                      opacity: 0.5,
                      child: SvgPicture.asset(
                        "assets/svg/chat.svg",
                      ),
                    ),
                    selectedIcon: SvgPicture.asset(
                      "assets/svg/chat.svg",
                    ),
                    label: "Chat",
                  ),
                  NavigationDestination(
                    icon: BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        return Badge(
                          backgroundColor: AppColors.errorColor,
                          isLabelVisible: OrderRepository.cart.isNotEmpty,
                          label: Text(
                            OrderRepository.cart.length.toString(),
                            style: CustomTextStyle.size14Weight400Text(
                              Colors.white,
                            ),
                          ),
                          offset: const Offset(10, -10),
                          child: Opacity(
                            opacity: 0.5,
                            child: SvgPicture.asset(
                              "assets/svg/cart.svg",
                            ),
                          ),
                        );
                      },
                    ),
                    selectedIcon: BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        return Badge(
                          backgroundColor: AppColors.errorColor,
                          isLabelVisible: OrderRepository.cart.isNotEmpty,
                          label: Text(
                            OrderRepository.cart.length.toString(),
                            style: CustomTextStyle.size14Weight400Text(
                              Colors.white,
                            ),
                          ),
                          offset: const Offset(10, -10),
                          child: SvgPicture.asset(
                            "assets/svg/cart.svg",
                          ),
                        );
                      },
                    ),
                    label: "Cart",
                  ),
                  NavigationDestination(
                    icon: Opacity(
                      opacity: 0.5,
                      child: SvgPicture.asset(
                        "assets/svg/profile.svg",
                      ),
                    ),
                    selectedIcon: SvgPicture.asset(
                      "assets/svg/profile.svg",
                    ),
                    label: "Profile",
                  ),
                ],
              ),
            );
          },
        ),
        body: _selectedIndex == 0
            ? _buildHomeBody(context)
            : _selectedIndex == 1
                ? const ChatListScreen()
                : _selectedIndex == 2
                    ? const OrderListScreen()
                    : const ProfileScreen(),
      ),
    );
  }

  Widget _buildHomeBody(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: SvgPicture.asset(
            "assets/svg/pattern-small.svg",
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Find Your \nFavorite Food",
                          style: CustomTextStyle.size30Weight600Text(),
                        ),
                      ),
                      Material(
                        color: AppColors().cardColor,
                        borderRadius: AppStyles.defaultBorderRadius,
                        child: InkWell(
                          borderRadius: AppStyles.defaultBorderRadius,
                          onTap: () {
                            Navigator.pushNamed(context, "/notification");
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              boxShadow: [AppStyles().largeBoxShadow],
                            ),
                            child: SvgPicture.asset(
                              "assets/svg/notification.svg",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Menu",
                        style: CustomTextStyle.size16Weight400Text(),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/foods");
                        },
                        style: TextButton.styleFrom(),
                        child: Text(
                          "View More",
                          style: CustomTextStyle.size14Weight400Text(
                            AppColors.secondaryDarkColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<FoodBloc, FoodState>(
                    builder: (context, state) {
                      if (state is FoodFetching) {
                        return const FoodItemShimmer();
                      } else if (state is FoodFetched) {
                        _foods.clear();
                        _foods.addAll(state.foods);
                      } else if (state is FoodError) {
                        return Center(
                          child: Text(state.message),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _foods.length > 5 ? 5 : _foods.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: FoodItem(food: _foods[index]),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
