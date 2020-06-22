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
    
    for i in 0..<6 {
      let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
      dataEntries.append(dataEntry)
    }
    //
    let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
    lineChartDataSet.lineWidth = 3
    //
    let lineChartData = LineChartData(dataSet: lineChartDataSet)
    return lineChartData
  }
  
  static func settingChart(lineChartView: LineChartView) {
    lineChartView.xAxis.drawGridLinesEnabled = false
    lineChartView.xAxis.drawLabelsEnabled = false
    lineChartView.xAxis.drawAxisLineEnabled = false
    
    lineChartView.leftAxis.drawGridLinesEnabled = false
    lineChartView.leftAxis.drawLabelsEnabled = false
    lineChartView.leftAxis.drawAxisLineEnabled = false
    
    lineChartView.rightAxis.drawLabelsEnabled = false
    lineChartView.rightAxis.drawGridLinesEnabled = false
    lineChartView.rightAxis.drawAxisLineEnabled = false
    
    lineChartView.legend.enabled = false
  }
}
