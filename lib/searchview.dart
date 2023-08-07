import 'package:flutter/cupertino.dart';
import 'package:livproducts/domain.dart';
import 'package:livproducts/repository.dart';

class ProductSearchView extends StatefulWidget {
  const ProductSearchView({super.key});

  @override
  _ProductSearchViewState createState() => _ProductSearchViewState();
}

class _ProductSearchViewState extends State<ProductSearchView> {
  final ProductRepository _repository = ProductRepository();
  final TextEditingController _searchController = TextEditingController();
  List<Record> _products = [];
  String _currentSortOption = 'Relevancia|0';

  Future<void> _fetchProducts() async {
    try {
      final products = await _repository.getProducts(
        _searchController.text,
        sortOption: _currentSortOption,
      );
      setState(() {
        _products = products;
      });
    } catch (e) {
      throw Exception(e);
      // setState(() {
      //   _products = [Record(productId: "productId", skuRepositoryId: "skuRepositoryId", productDisplayName: e.toString(), productType: "productType", productAvgRating: 4, promotionalGiftMessage: promotionalGiftMessage, listPrice: listPrice, minimumListPrice: minimumListPrice, maximumListPrice: maximumListPrice, promoPrice: promoPrice, minimumPromoPrice: minimumPromoPrice, maximumPromoPrice: maximumPromoPrice, isHybrid: isHybrid, isMarketPlace: isMarketPlace, isImportationProduct: isImportationProduct, brand: brand, seller: seller, category: category, dwPromotionInfo: dwPromotionInfo, categoryBreadCrumbs: categoryBreadCrumbs, smImage: smImage, lgImage: lgImage, xlImage: xlImage, groupType: groupType, plpFlags: plpFlags, variantsColor: variantsColor)];
      // });
    }
  }

  void _onSortOptionChanged(int index) {
    final sortOptions = [
      'Relevancia|0',
      'newArrival|1',
      'sortPrice|0',
      'sortPrice|1',
      'rating|1',
      'viewed|1',
      'sold|1',
    ];

    setState(() {
      _currentSortOption = sortOptions[index];
    });

    _fetchProducts();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Búsqueda de Producto'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Ingresa nombre de producto',
                onChanged: (value) {
                  value.isNotEmpty
                      ? _fetchProducts()
                      : setState(() => _products = []);
                },
                onSubmitted: (value) {
                  value.isNotEmpty
                      ? _fetchProducts()
                      : setState(() => _products = []);
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: CupertinoFormRow(
                prefix: const Text('Ordenar por:'),
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  onSelectedItemChanged: (index) => _onSortOptionChanged(index),
                  children: const [
                    Text('Relevancia'),
                    Text('Lo Más Nuevo'),
                    Text('Menor precio'),
                    Text('Mayor precio'),
                    Text('Calificaciones'),
                    Text('Más visto'),
                    Text('Más vendido'),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildProductItem(_products[index]),
              childCount: _products.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Record product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.network(
            product.lgImage,
            width: MediaQuery.of(context).size.width * 0.31416,
            height: MediaQuery.of(context).size.width * 0.31416,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.productDisplayName,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontSize: 16),
                ),
              ),
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
              if (product.variantsColor.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Colores disponibles:',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 4),
                      Wrap(
                        spacing: 4,
                        children: product.variantsColor
                            .map(
                              (color) => Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: _parseColor(color.colorHex),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _parseColor(String color) {
    final hexColor = color.replaceFirst('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }
}
