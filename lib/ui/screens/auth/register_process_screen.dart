import 'package:animo_eats/models/restaurant.dart';
import 'package:animo_eats/models/vendor.dart';
import 'package:animo_eats/services/firestore_db.dart';
import 'package:animo_eats/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animo_eats/ui/widgets/buttons/back_button.dart';
import 'package:animo_eats/ui/widgets/buttons/primary_button.dart';
import 'package:animo_eats/utils/app_colors.dart';
import 'package:animo_eats/utils/app_styles.dart';
import 'package:animo_eats/utils/custom_text_style.dart';
import 'package:animo_eats/utils/helpers.dart';
import 'package:hive/hive.dart';

class RegisterProcessScreen extends StatefulWidget {
  const RegisterProcessScreen({super.key});

  @override
  State<RegisterProcessScreen> createState() => _RegisterProcessScreenState();
}

class _RegisterProcessScreenState extends State<RegisterProcessScreen> {
  // get data from hive
  var box = Hive.box('myBox');

  // form key
  final _formKey = GlobalKey<FormState>();
  // controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    // set data to form fields
    _nameController.text = box.get('name', defaultValue: '');
    _phoneController.text = box.get('phone', defaultValue: '');
    _descriptionController.text = box.get('description', defaultValue: '');
    _locationController.text = box.get('location', defaultValue: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              "assets/svg/pattern-small.svg",
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: PrimaryButton(
                text: "Next",
                onTap: () async {
                  // validate form
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  // save data to hive
                  var box = Hive.box('myBox');
                  box.put('name', _nameController.text.trim());
                  box.put('phone', _phoneController.text.trim());
                  box.put('description', _descriptionController.text.trim());
                  box.put('location', _locationController.text.trim());

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const LoadingIndicator(),
                  );

                  FirestoreDatabase db = FirestoreDatabase();
                  Vendor vendor = Vendor.fromHive();
                  Restaurant restaurant = Restaurant.fromHive();

                  // Add Vendor Document
                  await db.addDocumentWithId(
                    'vendors',
                    vendor.name, // This is the document ID you want to set
                    vendor.toMap(),
                  );

                  // Add Restaurant Document with Vendor Reference and Restaurant fields
                  await db.addRestaurantWithVendorReference(
                      vendor.name, vendor.toMap(), restaurant);

                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/register/success');
                  }
                },
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 40,
                  ),
                  // check if previous page exists
                  if (ModalRoute.of(context)!.canPop) ...[
                    const CustomBackButton(),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    "Fill in your bio to get \nstarted",
                    style: CustomTextStyle.size25Weight600Text(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "This data will be displayed in your account \nprofile for security",
                    style: CustomTextStyle.size14Weight400Text(),
                  ),
                  const SizedBox(height: 20),

                  // form fields, store name, mobile number, location, and description
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        // Store Name
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [AppStyles.boxShadow7],
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Store name is required";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              fillColor: AppColors().cardColor,
                              filled: true,
                              hintText: "Store name",
                              hintStyle: CustomTextStyle.size14Weight400Text(
                                AppColors().secondaryTextColor,
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 20,
                              ),
                              enabledBorder: AppStyles().defaultEnabledBorder,
                              focusedBorder: AppStyles.defaultFocusedBorder(),
                              errorBorder: AppStyles.defaultErrorBorder,
                              focusedErrorBorder:
                                  AppStyles.defaultFocusedErrorBorder,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Phone Number
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [AppStyles.boxShadow7],
                          ),
                          child: TextFormField(
                            controller: _phoneController,
                            validator: (value) {
                              if (!validatePhoneNumber(value!)) {
                                return "Invalid phone number";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              fillColor: AppColors().cardColor,
                              filled: true,
                              hintText: "Mobile number",
                              hintStyle: CustomTextStyle.size14Weight400Text(
                                AppColors().secondaryTextColor,
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 20,
                              ),
                              enabledBorder: AppStyles().defaultEnabledBorder,
                              focusedBorder: AppStyles.defaultFocusedBorder(),
                              errorBorder: AppStyles.defaultErrorBorder,
                              focusedErrorBorder:
                                  AppStyles.defaultFocusedErrorBorder,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Location
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [AppStyles.boxShadow7],
                          ),
                          child: TextFormField(
                            controller: _locationController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Location is required";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              fillColor: AppColors().cardColor,
                              filled: true,
                              hintText: "Location",
                              hintStyle: CustomTextStyle.size14Weight400Text(
                                AppColors().secondaryTextColor,
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 20,
                              ),
                              enabledBorder: AppStyles().defaultEnabledBorder,
                              focusedBorder: AppStyles.defaultFocusedBorder(),
                              errorBorder: AppStyles.defaultErrorBorder,
                              focusedErrorBorder:
                                  AppStyles.defaultFocusedErrorBorder,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [AppStyles.boxShadow7],
                          ),
                          child: TextFormField(
                            controller: _descriptionController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Description is required";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              fillColor: AppColors().cardColor,
                              filled: true,
                              hintText: "Description",
                              hintStyle: CustomTextStyle.size14Weight400Text(
                                AppColors().secondaryTextColor,
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 20,
                              ),
                              enabledBorder: AppStyles().defaultEnabledBorder,
                              focusedBorder: AppStyles.defaultFocusedBorder(),
                              errorBorder: AppStyles.defaultErrorBorder,
                              focusedErrorBorder:
                                  AppStyles.defaultFocusedErrorBorder,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
