import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../core/constants/app_constants.dart';
import 'package:autopaleis/shared/services/car_service.dart';
import 'package:autopaleis/shared/models/car_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchText = "";
  final Set<BodyType> _selectedBodyTypes = {};
  final Set<FuelType> _selectedFuelTypes = {};

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarService>().fetchCars(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      final carService = context.read<CarService>();
      if (!carService.isLoading && carService.hasMoreData) {
        carService.fetchCars();
      }
    }
  }

  List<CarModel> _filterCars(List<CarModel> cars) {
    return cars.where((car) {
      final query = _searchText.toLowerCase();
      final matchesSearch = query.isEmpty ||
          car.brand.toLowerCase().contains(query) ||
          car.model.toLowerCase().contains(query);

      final matchesBodyType = _selectedBodyTypes.isEmpty || 
          _selectedBodyTypes.contains(car.body);

      final matchesFuelType = _selectedFuelTypes.isEmpty || 
          _selectedFuelTypes.contains(car.fuel);

      return matchesSearch && matchesBodyType && matchesFuelType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
            },
          ),
          IconButton(
            icon: const Icon(Icons.star),
            tooltip: "My Reviews",
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.myReviewsRoute);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.welcomeMessage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            
            // Top bar
            Row(
              children: [
                // Filters
                IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: "Filters",
                  onPressed: () {
                    _showFilterBottomSheet(context);
                  },
                ),
                
                const SizedBox(width: 8),
                
                // Search bar
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Zoek auto's...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Expanded(
              child: Consumer<CarService>(
                builder: (context, carService, child) {
                  if (carService.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (carService.error != null) {
                    return Center(child: Text(carService.error!));
                  }

                  if (carService.carList.isEmpty) {
                    return const Center(child: Text('No cars available'));
                  }

                  final filteredCars = _filterCars(carService.carList);

                  if (filteredCars.isEmpty) {
                    return const Center(child: Text('No cars match your filters'));
                  }

                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: filteredCars.length + (carService.hasMoreData && carService.isLoading && filteredCars.isNotEmpty ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index == filteredCars.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      
                      final car = filteredCars[index];
                      return _buildRentalCarCard(
                        context,
                        imageUrl: car.picture,
                        brand: car.brand,
                        model: car.model,
                        carType: car.body.name,
                        distance: '2.5 km', // Calculate from lat/long
                        price: '€${car.price}/day',
                        onTap: () {
                          // Navigate to car details
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Body Type',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: BodyType.values.map((bodyType) {
                      final isSelected = _selectedBodyTypes.contains(bodyType);
                      return FilterChip(
                        label: Text(bodyType.name),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedBodyTypes.add(bodyType);
                            } else {
                              _selectedBodyTypes.remove(bodyType);
                            }
                          });
                          setModalState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Fuel Type',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: FuelType.values.map((fuelType) {
                      final isSelected = _selectedFuelTypes.contains(fuelType);
                      return FilterChip(
                        label: Text(fuelType.name),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedFuelTypes.add(fuelType);
                            } else {
                              _selectedFuelTypes.remove(fuelType);
                            }
                          });
                          setModalState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      if (_selectedBodyTypes.isNotEmpty || _selectedFuelTypes.isNotEmpty)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedBodyTypes.clear();
                                _selectedFuelTypes.clear();
                              });
                              setModalState(() {});
                            },
                            child: const Text('Clear All'),
                          ),
                        ),
                      if (_selectedBodyTypes.isNotEmpty || _selectedFuelTypes.isNotEmpty)
                        const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRentalCarCard(
    BuildContext context, {
    required String imageUrl,
    required String brand,
    required String model,
    required String carType,
    required String distance,
    required String price,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Left column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand | Model
                    Text(
                      '$brand | $model',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Car body
                    Text(
                      carType,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 24),
                    // Distance and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          distance,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        Text(
                          price,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right column
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildCarImage(imageUrl),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarImage(String imageData) {
    try {
      // Remove data URL prefix if present
      String base64String = imageData;
      if (imageData.contains(',')) {
        base64String = imageData.split(',')[1];
      }
      
      final bytes = base64.decode(base64String);
      return Image.memory(
        bytes,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } catch (e) {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 100,
      color: Colors.grey[300],
      child: const Icon(Icons.directions_car, size: 40),
    );
  }
}
