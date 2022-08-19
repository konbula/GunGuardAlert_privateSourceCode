import 'package:flutter/material.dart';
import 'package:guntrackattempt1/models/data_tile_models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'components/body.dart';

class SalesData {
  SalesData(this.year, this.sales);
  int year;
  int sales;
}

class DataTileScreen extends StatefulWidget {
  static String routeName = "/data_tile";
  final HomocideDataTile dataTile;
  const DataTileScreen({required this.dataTile});
  @override
  State<DataTileScreen> createState() => _DataTileScreenState();
}

class _DataTileScreenState extends State<DataTileScreen> {
  late List<SalesData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  //can make my own custom tooltip later
  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        minHeight: 300,
        maxHeight: 650,
        panelBuilder: (sc) => PanelWidget(sc),
        body: SafeArea(
            child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black,
                  iconSize: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  widget.dataTile.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GraphThing(),
        ])),
      ),
    );
  }

  List<SalesData> getChartData() {
    List<SalesData> chartData = [];
    for (var i = 0; i < widget.dataTile.listData.length - 1; i++) {
      chartData.add(SalesData(
          widget.dataTile.listData[i][0], widget.dataTile.listData[i][1]));
    }
    return chartData;
  }

  Widget GraphThing() => Container(
        height: 300,
        width: 700,
        child: SfCartesianChart(
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            borderColor: Color.fromARGB(255, 155, 139, 139),
            borderWidth: 2,
          ),
          title: ChartTitle(text: widget.dataTile.graphTitle),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            LineSeries<SalesData, int>(
                enableTooltip: true,
                dataSource: _chartData,
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.sales,
                dataLabelSettings: DataLabelSettings(isVisible: true)),
          ],
          primaryXAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
        ),
      );

  Widget PanelWidget(ScrollController sc) => ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: sc,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 145, 143, 143),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: 36,
          ),
          buildAboutText(),
          SizedBox(
            height: 24,
          ),
        ],
      );
  Widget buildAboutText() => Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 17, color: Colors.black),
          ),
          SizedBox(
            height: 12,
          ),
          Text(widget.dataTile.description,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Colors.black))
        ]),
      );
}
