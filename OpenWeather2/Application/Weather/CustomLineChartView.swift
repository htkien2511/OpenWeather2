//
//  LineChartView.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/22/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import Charts

class CustomLineChartView {
  static func dataChart(values: [Double]) -> LineChartData {
    //
    var dataEntries: [ChartDataEntry] = []
    
    let xValue = [0.3, 1.45, 2.47, 3.5, 4.55, 5.6]
    for i in 0..<6 {
      let dataEntry = ChartDataEntry(x: xValue[i], y: values[i])
      dataEntries.append(dataEntry)
    }
    //
    let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
    lineChartDataSet.lineWidth = 3
    lineChartDataSet.circleRadius = 4
    lineChartDataSet.valueColors = [UIColor.white]
    lineChartDataSet.valueFont = UIFont(name: "Helvetica Neue", size: 20)!
    
    lineChartDataSet.valueFormatter = DefaultValueFormatter(decimals: 0)
    
    //
    let lineChartData = LineChartData(dataSet: lineChartDataSet)
    return lineChartData
  }
  
  static func settingChart(lineChartView: LineChartView) {
    lineChartView.xAxis.drawGridLinesEnabled = false
    lineChartView.xAxis.drawLabelsEnabled = false
    lineChartView.xAxis.drawAxisLineEnabled = false
    lineChartView.xAxis.axisMaximum = 6
    lineChartView.xAxis.axisMinimum = 0
    
    lineChartView.leftAxis.drawGridLinesEnabled = false
    lineChartView.leftAxis.drawLabelsEnabled = false
    lineChartView.leftAxis.drawAxisLineEnabled = false
    
    lineChartView.rightAxis.drawLabelsEnabled = false
    lineChartView.rightAxis.drawGridLinesEnabled = false
    lineChartView.rightAxis.drawAxisLineEnabled = false
    
    lineChartView.legend.enabled = false
    lineChartView.animate(xAxisDuration: 0.3)
  }
}
