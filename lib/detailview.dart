import 'package:flutter/cupertino.dart';
import 'package:livproducts/domain.dart';

class ProductDetailView extends StatelessWidget {
  final Record product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Product Details'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Image.network(
                    product.xlImage ?? product.lgImage ?? product.smImage,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.productDisplayName,
                  maxLines: 2,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  product.brand,
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
                const SizedBox(height: 8),
                if (product.listPrice != product.promoPrice)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '\$${product.listPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 18,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '\$${product.promoPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: CupertinoColors.systemRed, fontSize: 24),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Descripción:',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "SKU: ${product.skuRepositoryId}\n${product.productType}\n${product.groupType}",
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(CupertinoIcons.star_fill,
                        color: CupertinoColors.systemYellow),
                    const SizedBox(width: 4),
                    Text(
                      product.productAvgRating.toStringAsFixed(1),
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      CupertinoIcons.tag_fill,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.category,
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (product.variantsColor.isNotEmpty == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Colores disponibles:',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                                fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Wrap(
                              spacing: 8,
                              children: product.variantsColor
                                  .map(
                                    (color) => Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                          color: _parseColor(color.colorHex),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              strokeAlign: 4,
                                              color: CupertinoTheme.of(context)
                                                  .primaryColor)),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                CupertinoButton.filled(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<int, Widget> _buildColorSegments(BuildContext context) {
    final Map<int, Widget> colorSegments = {};
    for (int i = 0; i < product.variantsColor.length; i++) {
      final color = product.variantsColor[i];
      colorSegments[i] = Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _parseColor(color.colorHex),
          shape: BoxShape.circle,
        ),
      );
    }
    return colorSegments;
  }

  Color _parseColor(String color) {
    final hexColor = color.replaceFirst('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }
}
