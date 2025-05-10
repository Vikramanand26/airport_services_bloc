// lib/presentation/pages/airport_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/airport_bloc/airport_bloc.dart';
import '../blocs/airport_bloc/airport_state.dart';
import '../widgets/airport_card.dart';

class AirportListPage extends StatelessWidget {
  const AirportListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Airports'),
      ),
      body: BlocBuilder<AirportBloc, AirportState>(
        builder: (context, state) {
          if (state is AirportLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AirportsByEmailDomainLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Airports accessible with ${state.emailDomain}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: state.airports.isEmpty
                      ? const Center(
                    child: Text('No airports available for this email domain'),
                  )
                      : ListView.builder(
                    itemCount: state.airports.length,
                    itemBuilder: (context, index) {
                      return AirportCard(airport: state.airports[index]);
                    },
                  ),
                ),
              ],
            );
          } else if (state is DeployedAirportsLoaded) {
            return ListView.builder(
              itemCount: state.airports.length,
              itemBuilder: (context, index) {
                return AirportCard(airport: state.airports[index]);
              },
            );
          } else if (state is AirportError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text('Enter your email to see available airports'),
          );
        },
      ),
    );
  }
}