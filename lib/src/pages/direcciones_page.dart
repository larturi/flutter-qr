import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class DireccionesPage extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtenerScans();
    
    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        
        if(!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final scans = snapshot.data;

        if(scans.length == 0) {
          return Center(child: Text('No hay información'));
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (BuildContext context, int i) {
            return Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red),
              onDismissed: (direction) => scansBloc.borrarScan(scans[i].id),
              child: ListTile(
                leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor),
                title: Text(scans[i].valor),
                subtitle: Text('ID: ${scans[i].id.toString()}'),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                onTap: () => utils.abrirScan(context, scans[i])
              ),
            );
          },
        );

      }

      

    );
  }
}