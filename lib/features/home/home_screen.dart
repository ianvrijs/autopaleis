import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'dart:convert';

import '../../core/constants/app_constants.dart';
import 'package:autopaleis/shared/services/car_service.dart';
import 'package:autopaleis/shared/models/car_model.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/favorites_service.dart';
import '../../shared/widgets/car_card.dart';

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
      context.read<FavoritesService>().loadFavorites();
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
        title: const Text(AppConstants.homeTitle)
      ),
      body: Stack(
        children: [
          Padding(
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

                    // Sort
                    IconButton(
                      icon: const Icon(Icons.sort),
                      tooltip: "Sort",
                      onPressed: () {
                        _showSortBottomSheet(context);
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
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
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
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (carService.error != null) {
                        return Center(child: Text(carService.error!));
                      }

                      if (carService.carList.isEmpty) {
                        return const Center(
                            child: Text('No cars available'));
                      }

                      final filteredCars =
                          _filterCars(carService.carList);

                      if (filteredCars.isEmpty) {
                        return const Center(
                            child: Text('No cars match your filters'));
                      }

                      return ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: filteredCars.length +
                            (carService.hasMoreData &&
                                    carService.isLoading &&
                                    filteredCars.isNotEmpty
                                ? 1
                                : 0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          if (index == filteredCars.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                  child: CircularProgressIndicator()),
                            );
                          }

                          final car = filteredCars[index];
                          return CarCard(car: car);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, AppConstants.loginRoute);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.star),
                    tooltip: "My Reviews",
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppConstants.myReviewsRoute);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.bus_alert),
                    tooltip: "My Rentals",
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppConstants.myRentalsRoute);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle),
                    tooltip: "Profiel",
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppConstants.profileRoute);
                    },
                  ),
                  if (context.watch<AuthService>().isAdmin)
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings),
                      tooltip: "Admin Paneel",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppConstants.adminDashboardRoute);
                      },
                    ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: null,
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

  void _showSortBottomSheet(BuildContext context) {
    final carService = context.read<CarService>();
    String? selectedSort = carService.sortCriteria.isNotEmpty 
        ? carService.sortCriteria.first 
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Padding(
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
                        'Sort By',
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
                  
                  // Sort options
                  RadioListTile<String>(
                    title: const Text('Price: Low to High'),
                    value: 'price,asc',
                    groupValue: selectedSort,
                    onChanged: (value) {
                      setModalState(() {
                        selectedSort = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Price: High to Low'),
                    value: 'price,desc',
                    groupValue: selectedSort,
                    onChanged: (value) {
                      setModalState(() {
                        selectedSort = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Brand: A to Z'),
                    value: 'brand,asc',
                    groupValue: selectedSort,
                    onChanged: (value) {
                      setModalState(() {
                        selectedSort = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Brand: Z to A'),
                    value: 'brand,desc',
                    groupValue: selectedSort,
                    onChanged: (value) {
                      setModalState(() {
                        selectedSort = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Model Year: Newest First'),
                    value: 'modelYear,desc',
                    groupValue: selectedSort,
                    onChanged: (value) {
                      setModalState(() {
                        selectedSort = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Model Year: Oldest First'),
                    value: 'modelYear,asc',
                    groupValue: selectedSort,
                    onChanged: (value) {
                      setModalState(() {
                        selectedSort = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Number of Seats'),
                    value: 'nrOfSeats,desc',
                    groupValue: selectedSort,
                    onChanged: (value) {
                      setModalState(() {
                        selectedSort = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      if (selectedSort != null)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              carService.setSortCriteria([]);
                              Navigator.pop(context);
                            },
                            child: const Text('Clear Sort'),
                          ),
                        ),
                      if (selectedSort != null)
                        const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedSort != null) {
                              carService.setSortCriteria([selectedSort!]);
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            );
          },
        );
      },
    );
  }
}
