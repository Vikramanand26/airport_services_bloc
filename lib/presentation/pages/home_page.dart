// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/airport_bloc/airport_bloc.dart';
import '../blocs/airport_bloc/airport_event.dart';
import '../blocs/airport_bloc/airport_state.dart';
import '../widgets/airport_card.dart';
import '../widgets/email_input_form.dart';
import 'airport_list_page.dart';
import '../../domain/entities/airport.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Airport> _allAirports = [];
  List<Airport> _filteredAirports = [];
  String _emailDomain = '';
  bool _showFiltered = false;
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Fetch all deployed airports when the page loads
    context.read<AirportBloc>().add(GetDeployedAirportsEvent());
  }

  void _updateAirportsFromState(AirportState state) {
    if (state is DeployedAirportsLoaded) {
      _allAirports = state.airports;
      if (!_showFiltered) _filteredAirports = state.airports;
    } else if (state is AirportsByEmailDomainLoaded) {
      _emailDomain = state.emailDomain;
      // Only show airports that match the codes in the loaded state
      final codes = state.airports.map((a) => a.airportCode).toSet();
      // If there are no codes, filteredAirports should be empty
      if (codes.isEmpty) {
        _filteredAirports = [];
      } else {
        _filteredAirports =
            _allAirports.where((a) => codes.contains(a.airportCode)).toList();
      }
    }
  }

  void _onSearch() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AirportBloc>().add(
            GetAirportsByEmailDomainEvent(_emailController.text),
          );
      setState(() {
        _showFiltered = true;
      });
      // Print filtered data for debugging
      print('--- Filtered airports (after search) ---');
      for (var a in _filteredAirports) {
        print('  ${a.airportName} (${a.airportCode})');
      }
      print('---------------------------------------');
    }
  }

  void _onClearSearch() {
    setState(() {
      _showFiltered = false;
      _emailController.clear();
      _filteredAirports = List<Airport>.from(_allAirports);
      _emailDomain = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E24AA), Color(0xFF512DA8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF8E24AA).withOpacity(0.18),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Animated flying airplane behind the AppBar content
                _AppBarFlyingPlane(),
                Positioned(
                  right: -30,
                  top: -20,
                  child: Opacity(
                    opacity: 0.10,
                    child: Icon(Icons.flight, size: 180, color: Colors.white),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Text(
                      'Airport Access',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 24,
                  top: 24,
                  child:
                      Icon(Icons.flight_takeoff, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocConsumer<AirportBloc, AirportState>(
        listener: (context, state) {
          _updateAirportsFromState(state);
          if (state is AirportsByEmailDomainLoaded) {
            setState(() {
              _showFiltered = true;
            });
            // Print filtered data for debugging
            print('--- Filtered airports (after search) ---');
            for (var a in _filteredAirports) {
              print('  ${a.airportName} (${a.airportCode})');
            }
            print('---------------------------------------');
          }
          if (state is DeployedAirportsLoaded) {
            setState(() {
              if (!_showFiltered) _filteredAirports = state.airports;
            });
          }
        },
        builder: (context, state) {
          _updateAirportsFromState(state);
          bool isLoading = state is AirportLoading;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Email input form at the top
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 28, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF8E24AA).withOpacity(0.13),
                          blurRadius: 24,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 28, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.mark_email_read,
                                  color: Color(0xFF8E24AA), size: 28),
                              SizedBox(width: 12),
                              Text('Check Your Airport Access',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8E24AA),
                                    fontSize: 18,
                                  )),
                            ],
                          ),
                          SizedBox(height: 22),
                          Form(
                            key: _formKey,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(fontSize: 17),
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'Enter your email address',
                                      prefixIcon: Icon(Icons.alternate_email,
                                          color: Color(0xFF8E24AA)),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                            color: Color(0xFF8E24AA),
                                            width: 1.3),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                            color: Color(0xFF8E24AA),
                                            width: 1.3),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.search,
                                            color: Color(0xFF8E24AA)),
                                        onPressed: _onSearch,
                                        tooltip: 'Search',
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(
                                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                if (_showFiltered)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(14),
                                        onTap: _onClearSearch,
                                        child: Container(
                                          height: 48,
                                          width: 48,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Icon(Icons.clear,
                                              color: Color(0xFF8E24AA)),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          BlocBuilder<AirportBloc, AirportState>(
                            builder: (context, state) {
                              if (state is AirportsByEmailDomainLoaded) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    'Showing airports for ${state.emailDomain}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Title for the airport list
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 18, bottom: 8),
                    child: Text(
                      _showFiltered &&
                              _filteredAirports.isNotEmpty &&
                              _emailDomain.isNotEmpty
                          ? 'Airports You Have Access To'
                          : 'All Deployed Airports',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8E24AA),
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),

                  // Airport list or loader
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: isLoading
                        ? Center(
                            child: _AeroplaneLoader(),
                          )
                        : _showFiltered
                            ? (_filteredAirports.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.airport_shuttle,
                                            color: Color(0xFF8E24AA)
                                                .withOpacity(0.18),
                                            size: 48),
                                        SizedBox(height: 12),
                                        Text(
                                            'No airports available for this email domain',
                                            style: TextStyle(
                                                color: Color(0xFF8E24AA),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _filteredAirports.length,
                                    itemBuilder: (context, index) {
                                      return AirportCard(
                                          airport: _filteredAirports[index]);
                                    },
                                  ))
                            : (_allAirports.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.airport_shuttle,
                                            color: Color(0xFF8E24AA)
                                                .withOpacity(0.18),
                                            size: 48),
                                        SizedBox(height: 12),
                                        Text('No airports available',
                                            style: TextStyle(
                                                color: Color(0xFF8E24AA),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _allAirports.length,
                                    itemBuilder: (context, index) {
                                      return AirportCard(
                                          airport: _allAirports[index]);
                                    },
                                  )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AeroplaneLoader extends StatefulWidget {
  @override
  State<_AeroplaneLoader> createState() => _AeroplaneLoaderState();
}

class _AeroplaneLoaderState extends State<_AeroplaneLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.4;
    return SizedBox(
      width: width,
      height: 80,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Move airplane left to right and slightly up
          final dx = _animation.value * (width - 56);
          final dy = -20 * (_animation.value); // move up as it moves right
          return Transform.translate(
            offset: Offset(dx, dy),
            child: Transform.rotate(
              angle: -0.2 + 0.2 * _animation.value, // slight upward tilt
              child: Icon(
                Icons.flight_takeoff,
                color: Color(0xFF8E24AA),
                size: 56,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AppBarFlyingPlane extends StatefulWidget {
  const _AppBarFlyingPlane();
  @override
  State<_AppBarFlyingPlane> createState() => _AppBarFlyingPlaneState();
}

class _AppBarFlyingPlaneState extends State<_AppBarFlyingPlane>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(seconds: 2)); // Add 2 second pause
        _controller.reset();
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = 120.0; // AppBar height
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Move from bottom left to top right
          final dx = _animation.value * (width - 54);
          final dy = height - 54 - (_animation.value * (height - 54));
          return Transform.translate(
            offset: Offset(dx, dy),
            child: Opacity(
              opacity: 0.18,
              child: Icon(
                Icons.flight_takeoff,
                color: Colors.white,
                size: 54,
              ),
            ),
          );
        },
      ),
    );
  }
}
