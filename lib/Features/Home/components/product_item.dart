import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moboom/Features/Home/models/product.dart';
import 'package:moboom/Utils/app_images.dart';
import 'package:shimmer/shimmer.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: product.thumbnailImage,
                placeholder: (context, url) => SizedBox(
                  height: screenWidth * 0.4,
                  width: double.infinity,
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
                imageBuilder: (context, imageProvider) => Container(
                  height: screenWidth * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  color: Colors.black.withOpacity(0.4),
                  child: Image.asset(
                    AppImages.heartOutline,
                    height: 14,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${product.price}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                RatingBar(
                  itemCount: 5,
                  itemSize: 14,
                  initialRating: product.rating,
                  allowHalfRating: true,
                  ignoreGestures: true,
                  ratingWidget: RatingWidget(
                    full: const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    half: const Icon(
                      Icons.star_half,
                      color: Colors.yellow,
                    ),
                    empty: Icon(
                      Icons.star_border_outlined,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  onRatingUpdate: (value) {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
