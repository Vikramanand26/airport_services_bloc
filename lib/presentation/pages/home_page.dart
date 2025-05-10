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
      _filteredAirports =
          _allAirports.where((a) => codes.contains(a.airportCode)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7B1FA2), Color(0xFF512DA8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF7B1FA2).withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  right: -30,
                  top: -20,
                  child: Opacity(
                    opacity: 0.08,
                    child: Icon(Icons.flight, size: 180, color: Colors.white),
                  ),
                ),
                Center(
                  child: Text(
                    'Airport Access',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 18,
                  child:
                      Icon(Icons.flight_takeoff, color: Colors.white, size: 28),
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
          }
          if (state is DeployedAirportsLoaded) {
            setState(() {
              if (!_showFiltered) _filteredAirports = state.airports;
            });
          }
        },
        builder: (context, state) {
          _updateAirportsFromState(state);
          return Column(
            children: [
              // Email input form at the top
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.mark_email_read,
                              color: Color(0xFF7B1FA2), size: 28),
                          SizedBox(width: 10),
                          Text('Check Your Airport Access',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7B1FA2),
                                fontSize: 17,
                              )),
                        ],
                      ),
                      SizedBox(height: 18),
                      const EmailInputForm(),
                      BlocBuilder<AirportBloc, AirportState>(
                        builder: (context, state) {
                          if (state is AirportsByEmailDomainLoaded) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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

              // Toggle button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_filteredAirports.isNotEmpty && _allAirports.isNotEmpty)
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF7B1FA2).withOpacity(0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _showFiltered = !_showFiltered;
                          });
                        },
                        icon: Icon(
                            _showFiltered ? Icons.public : Icons.account_box,
                            color: Color(0xFF7B1FA2)),
                        label: Text(
                          _showFiltered
                              ? 'Show All Airports'
                              : 'Show My Access',
                          style: TextStyle(color: Color(0xFF7B1FA2)),
                        ),
                      ),
                  ],
                ),
              ),

              // Status and error messages
              BlocBuilder<AirportBloc, AirportState>(
                builder: (context, state) {
                  if (state is AirportLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is AirportError) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Error: ${state.message}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Title for the airport list
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _showFiltered
                      ? (_emailDomain.isNotEmpty
                          ? 'Airports You Have Access To'
                          : 'Filtered Airports')
                      : 'All Deployed Airports',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2),
                  ),
                ),
              ),

              // Airport list
              Expanded(
                child: _showFiltered
                    ? (_filteredAirports.isEmpty
                        ? const Center(
                            child: Text(
                                'No airports available for this email domain'))
                        : ListView.builder(
                            itemCount: _filteredAirports.length,
                            itemBuilder: (context, index) {
                              return AirportCard(
                                  airport: _filteredAirports[index]);
                            },
                          ))
                    : (_allAirports.isEmpty
                        ? const Center(child: Text('No airports available'))
                        : ListView.builder(
                            itemCount: _allAirports.length,
                            itemBuilder: (context, index) {
                              return AirportCard(airport: _allAirports[index]);
                            },
                          )),
              ),
            ],
          );
        },
      ),
    );
  }
}
