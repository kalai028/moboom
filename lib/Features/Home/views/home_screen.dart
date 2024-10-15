import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moboom/Features/Home/bloc/home_bloc.dart';
import 'package:moboom/Features/Home/components/product_item.dart';
import 'package:moboom/Utils/app_images.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeBloc>()
      ..add(GetCategoriesEvent())
      ..add(GetAllProductsEvent(pageNo: currentPage));
    super.initState();
  }

  //CONTROLLERS
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  //FOOTER MENUS
  List<String> options = [
    'Privacy center',
    'Privacy & cookie policy',
    'Manage Cookies',
    'Terms & Conditions',
    'Copyright Notice',
    'Imprint'
  ];

  //FOR PAGINATION
  int currentPage = 0;

  //TO SELECT CATEGORY (DROPDOWN BUTTON)
  String? selectedCategory;

  //THIS FUNCTION IS USED TO GO TO THE TOP OF THE SCREEN WHEN CLICKING PAGE NUMBERS TO SEE NEW PRODUCTS
  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //APPBAR
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Image.asset(
            AppImages.menuIcon,
            height: 30,
          ),
        ),
        title: Image.asset(
          AppImages.brandLogo,
          height: 28,
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),

      //
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Column(
                children: [
                  //SEARCH FIELD
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'What do you want to buy today?',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                          AppImages.searchIcon,
                        ),
                      ),
                      suffixIconConstraints:
                          const BoxConstraints(maxHeight: 20),
                    ),
                    onChanged: (value) {
                      setState(() {
                        currentPage = 0;
                        selectedCategory = null;
                      });

                      context.read<HomeBloc>().add(SearchProductsEvent(
                          keyword: value.trim(), pageNo: currentPage));
                    },
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Select Category',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      BlocBuilder<HomeBloc, HomeState>(
                        buildWhen: (previous, current) => current
                            is CategoryState, //TO AVOID REBUILDING EVERY TIME WHEN THE PRODUCTS ARE LOADING
                        builder: (context, state) {
                          if (state is CategoriesLoadingState) {
                            return Expanded(
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                height: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: const Color(0xFFf1f2f6),
                                  highlightColor: Colors.white,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (state is CategoriesLoadedState) {
                            return Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  value: selectedCategory,
                                  hint: const Text(
                                    'Choose Category',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  items: state.categories
                                      .map((category) => DropdownMenuItem(
                                          value: category.slug,
                                          child: Text(category.name)))
                                      .toList(),
                                  isExpanded: true,
                                  buttonStyleData: ButtonStyleData(
                                    height: 46,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  iconStyleData: IconStyleData(
                                    icon: Image.asset(
                                      AppImages.arrowDown,
                                      height: 20,
                                    ),
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 250,
                                    width: 220,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchController.clear();
                                      selectedCategory = value;
                                      currentPage = 0;
                                    });
                                    context.read<HomeBloc>().add(
                                        GetCategoryProductsEvent(
                                            category: selectedCategory!,
                                            pageNo: currentPage));
                                  },
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.brown,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Title Text',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            style:
                                GoogleFonts.poppins(height: 1.4, fontSize: 14),
                            children: const [
                              TextSpan(
                                  text:
                                      'Slash Sales begins in April.  Get upto 80% Discount of all products ',
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(
                                text: ' Read More',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (previous, current) => current is! CategoryState,
                    builder: (context, state) {
                      if (state is ProductsLoadingState) {
                        return GridView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.62,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16),
                          itemBuilder: (context, index) => Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Shimmer.fromColors(
                              baseColor: const Color(0xFFf1f2f6),
                              highlightColor: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (state is ProductsLoadedState) {
                        return state.products.isEmpty
                            ? const SizedBox(
                                height: 250,
                                child: Center(
                                  child: Text('No products found'),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GridView.builder(
                                    itemCount: state.products.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 0.62,
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 16,
                                            crossAxisSpacing: 16),
                                    itemBuilder: (context, index) =>
                                        ProductItem(
                                            product: state.products[index]),
                                  ),
                                  const SizedBox(height: 20),
                                  if (state.totalProductsCount >
                                      state.productsLimitOnPage)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: NumberPaginator(
                                        initialPage: currentPage,
                                        numberPages: (state.totalProductsCount /
                                                state.productsLimitOnPage)
                                            .round(), //TO HIDE THE PAGINATION NUMBERS IF THE NO OF PRODUCTS IS LESS THAN THE LIMIT
                                        onPageChange: (p0) {
                                          setState(() {
                                            currentPage = p0;
                                          });

                                          if (_searchController
                                              .text.isNotEmpty) {
                                            context.read<HomeBloc>().add(
                                                SearchProductsEvent(
                                                    keyword: _searchController
                                                        .text
                                                        .trim(),
                                                    pageNo: currentPage));
                                          } else if (selectedCategory != null) {
                                            context.read<HomeBloc>().add(
                                                GetCategoryProductsEvent(
                                                    category: selectedCategory!,
                                                    pageNo: currentPage));
                                          } else {
                                            context.read<HomeBloc>().add(
                                                GetAllProductsEvent(
                                                    pageNo: currentPage));
                                          }
                                          scrollToTop();
                                        },
                                        config: NumberPaginatorUIConfig(
                                          buttonSelectedBackgroundColor:
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          buttonShape:
                                              const RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              );
                      } else if (state is ProductsErrorState) {
                        return SizedBox(
                          height: 250,
                          child: Center(
                            child: Text(state.error),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),

            //FOOTER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SOCIALS',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Image.asset(
                                  AppImages.facebook,
                                  height: 28,
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  AppImages.twitter,
                                  height: 28,
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  AppImages.instagram,
                                  height: 28,
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  AppImages.tiktok,
                                  height: 28,
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  AppImages.snapchat,
                                  height: 28,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'PLATFORMS',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Image.asset(
                                AppImages.android,
                                height: 28,
                              ),
                              const SizedBox(width: 8),
                              Image.asset(
                                AppImages.ios,
                                height: 28,
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'SIGN UP',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Your Email',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(),
                      minimumSize: const Size(double.infinity, 44),
                    ),
                    onPressed: () {},
                    child: const Text('SUBSCRIBE'),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'By clicking the SUBSCRIBE button, you are agreeing to our',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Privacy & Cookie Policy',
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      '© 2010 - 2022 All Rights Reserved',
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final menu in options)
                        Container(
                          padding: const EdgeInsets.only(right: 8),
                          decoration:
                              options.indexOf(menu) == options.length - 1
                                  ? null
                                  : const BoxDecoration(
                                      border: BorderDirectional(
                                        end: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                          child: Text(
                            menu,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
