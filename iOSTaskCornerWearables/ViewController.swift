//
//  ViewController.swift
//  iOSTaskCornerWearables
//
//  Created by Bálint Németh on 2018. 09. 10..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import AVFoundation
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var punchesLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var powerLbl: UILabel!
    @IBOutlet weak var jabLbl: UILabel!
    @IBOutlet weak var leftHookLbl: UILabel!
    @IBOutlet weak var leftUCLbl: UILabel!
    @IBOutlet weak var crossLbl: UILabel!
    @IBOutlet weak var rightHookLbl: UILabel!
    @IBOutlet weak var rightUCLbl: UILabel!
    @IBOutlet weak var maxIntensityLbl: UILabel!
    @IBOutlet weak var minIntesityLbl: UILabel!
    var datas = [Data]()
    
    @IBOutlet weak var rightHorizontalBarChart: HorizontalBarChartView!
    @IBOutlet weak var leftHorizontalBarChart: HorizontalBarChartView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseDataFromCSV()
        parseStat()
        parseBreakdowns(count: 3)
        maxAndMinIntensity(expectedVal: 8.33)
    }
    
    func parseDataFromCSV() {
        
        let path = Bundle.main.path(forResource: "WSBFvI_Round1", ofType: "csv")!
        
        do{
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                
                let ts = row["ts"]!
                let punch_type_id = Int(row[" punch_type_id"]!)!
                let speed_mph = Double(row[" speed_mph"]!)!
                let power_g = Double(row[" power_g"]!)!
                
                let data = Data(ts: ts, punch_type_id: punch_type_id, speed_mph: speed_mph, power_g: power_g)
                datas.append(data)
            }
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func parseStat() {
        
        var totalSpeed: Double = 0.0
        var totalPower: Double = 0.0
        
        for index in 0..<datas.count {
            
            totalSpeed += datas[index].speed_mph
            totalPower += datas[index].power_g
        }
        
        speedLbl.text = String(round((totalSpeed / Double(datas.count)) * 10) / 10)
        powerLbl.text = String(round((totalPower / Double(datas.count)) * 10) / 10)
        punchesLbl.text = String(datas.count)
    }
    
    func parseBreakdowns(count: Int) {

        var jab: Int = 0
        var cross: Int = 0
        var rightHook: Int = 0
        var leftHook: Int = 0
        var rightUC: Int = 0
        var leftUC: Int = 0

        for index in 0..<datas.count {
            if datas[index].punch_type_id == 0 {

                jab += 1
            } else if datas[index].punch_type_id == 1 {

                leftHook += 1
            } else if datas[index].punch_type_id == 2 {

                leftUC += 1
            } else if datas[index].punch_type_id == 3 {

                cross += 1
            } else if datas[index].punch_type_id == 4 {

                rightHook += 1
            } else {

                rightUC += 1
            }
        }
        
        let numbers = [jab, cross, leftHook, rightHook, leftUC, rightUC]
        var maxNumber = Int()
        
        for number in numbers {
            maxNumber = max(maxNumber, number as Int)
        }
        
        jabLbl.text = String(jab)
        crossLbl.text = String(cross)
        rightHookLbl.text = String(rightHook)
        leftHookLbl.text = String(leftHook)
        rightUCLbl.text = String(rightUC)
        leftUCLbl.text = String(leftUC)
        
        rightHorizontalBarChart.drawBarShadowEnabled = false
        rightHorizontalBarChart.drawValueAboveBarEnabled = true
        leftHorizontalBarChart.drawBarShadowEnabled = false
        leftHorizontalBarChart.drawValueAboveBarEnabled = true
        rightHorizontalBarChart.pinchZoomEnabled = false
        rightHorizontalBarChart.doubleTapToZoomEnabled = false
        leftHorizontalBarChart.pinchZoomEnabled = false
        leftHorizontalBarChart.doubleTapToZoomEnabled = false
        
        rightHorizontalBarChart.maxVisibleCount = 100
        rightHorizontalBarChart.backgroundColor = UIColor.black
        rightHorizontalBarChart.drawBordersEnabled = false
        rightHorizontalBarChart.chartDescription?.textColor = UIColor.black
        leftHorizontalBarChart.maxVisibleCount = 100
        leftHorizontalBarChart.backgroundColor = UIColor.black
        leftHorizontalBarChart.drawBordersEnabled = false
        leftHorizontalBarChart.chartDescription?.textColor = UIColor.black
    
        let xAxisForRight  = rightHorizontalBarChart.xAxis
        xAxisForRight.enabled = false
        let xAxisForLeft  = leftHorizontalBarChart.xAxis
        xAxisForLeft.enabled = false
        
        let leftAxisForRight = rightHorizontalBarChart.leftAxis
        leftAxisForRight.enabled = false
        leftAxisForRight.drawAxisLineEnabled = false
        leftAxisForRight.drawGridLinesEnabled = false
        leftAxisForRight.axisMinimum = 0.0
        leftAxisForRight.axisMaximum = Double(maxNumber)
        let leftAxisForLeft = leftHorizontalBarChart.leftAxis
        leftAxisForLeft.enabled = false
        leftAxisForLeft.drawAxisLineEnabled = false
        leftAxisForLeft.drawGridLinesEnabled = false
        leftAxisForLeft.axisMinimum = 0.0
        leftAxisForLeft.axisMaximum = Double(maxNumber)
        
        let rightAxisForRight = rightHorizontalBarChart.rightAxis
        rightAxisForRight.enabled = false
        rightAxisForRight.drawAxisLineEnabled = false
        rightAxisForRight.drawGridLinesEnabled = false
        rightAxisForRight.axisMinimum = 0.0
        let rightAxisForLeft = leftHorizontalBarChart.rightAxis
        rightAxisForLeft.enabled = false
        rightAxisForLeft.drawAxisLineEnabled = false
        rightAxisForLeft.drawGridLinesEnabled = false
        rightAxisForLeft.axisMinimum = 0.0
        
        let labelRight = rightHorizontalBarChart.legend
        labelRight.enabled =  false
        let labelLeft = leftHorizontalBarChart.legend
        labelLeft.enabled =  false
        
        rightHorizontalBarChart.fitBars = false
        leftHorizontalBarChart.fitBars = false
        
        let barWidth = 1.0
        let spaceForBar =  10.0;
        
        var yValsForRight = [BarChartDataEntry]()
        
        yValsForRight.append(BarChartDataEntry(x: 0 * spaceForBar, y: Double(rightUC)))
        yValsForRight.append(BarChartDataEntry(x: 1 * spaceForBar, y: Double(rightHook)))
        yValsForRight.append(BarChartDataEntry(x: 2 * spaceForBar, y: Double(cross)))
        
        var yValsForLeft = [BarChartDataEntry]()
        
        yValsForLeft.append(BarChartDataEntry(x: 0 * spaceForBar, y: Double(leftUC)))
        yValsForLeft.append(BarChartDataEntry(x: 1 * spaceForBar, y: Double(leftHook)))
        yValsForLeft.append(BarChartDataEntry(x: 2 * spaceForBar, y: Double(jab)))
        
        let set1 = BarChartDataSet(values: yValsForRight, label: nil)
        let color1 = UIColor(red: 0, green: 195, blue: 250)
        set1.colors = [color1]
        set1.highlightEnabled = false
        let data1 = BarChartData(dataSet: set1)
        data1.barWidth = barWidth
        rightHorizontalBarChart.data = data1
        rightHorizontalBarChart.notifyDataSetChanged()
        
        let set2 = BarChartDataSet(values: yValsForLeft, label: nil)
        let color2 = UIColor(red: 35, green: 183, blue: 49)
        set2.colors = [color2]
        set2.highlightEnabled = false
        let data2 = BarChartData(dataSet: set2)
        data2.barWidth = barWidth
        leftHorizontalBarChart.data = data2
        leftHorizontalBarChart.notifyDataSetChanged()
        leftHorizontalBarChart.flipX()
    }
    
    func timeAnalysing() -> [Int] {
        
        var periods = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var times = [Double]()
        
        for index in 0..<datas.count {
            
            let splitTimeArr = datas[index].ts.split(separator: ":")
            let hour = round(Double(splitTimeArr[0])! * 1000) / 1000
            let min = round(Double(splitTimeArr[1])! * 1000) / 1000
            let sec = round(Double(splitTimeArr[2])! * 1000) / 1000
            let totalSec = (hour * 3600) + (min * 60) + sec
            
            times.append(totalSec)
        }
        
        for index in 0..<times.count {

            if times[index] <= 15 {
                periods[0] += 1
            } else if (times[index] > 15) && (times[index] <= 30) {
                periods[1] += 1
            } else if (times[index] > 30) && (times[index] <= 45) {
                periods[2] += 1
            } else if (times[index] > 45) && (times[index] <= 60) {
                periods[3] += 1
            } else if (times[index] > 60) && (times[index] <= 75) {
                periods[4] += 1
            } else if (times[index] > 75) && (times[index] <= 90) {
                periods[5] += 1
            } else if (times[index] > 90) && (times[index] <= 105) {
                periods[6] += 1
            } else if (times[index] > 105) && (times[index] <= 120) {
                periods[7] += 1
            } else if (times[index] > 120) && (times[index] <= 135) {
                periods[8] += 1
            } else if (times[index] > 135) && (times[index] <= 150) {
                periods[9] += 1
            } else if (times[index] > 150) && (times[index] <= 165) {
                periods[10] += 1
            } else {
                periods[11] += 1
            }
        }
        
        return periods
    }
    
    func maxAndMinIntensity(expectedVal: Double) {
        
        let periods = timeAnalysing()
        var intensities = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        for index in 0..<periods.count {
            
            if periods[index] == 0 {
                intensities[index] = 0
            } else if Double(periods[index]) < expectedVal {
                intensities[index] = Int((100 - ((Double(periods[index]) / expectedVal) * 100)) * (-1))
            } else {
                intensities[index] = Int(((Double(periods[index]) - expectedVal) / expectedVal) * 100)
            }
        }
        
        maxIntensityLbl.text = "+\(intensities.max()!)%"
        minIntesityLbl.text = "-\(intensities.min()!)%"
        
        lineChartView.backgroundColor = UIColor.black
        lineChartView.chartDescription = nil
        lineChartView.pinchZoomEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.maxVisibleCount = 100
        
        let xAxis = lineChartView.xAxis
        //set to false and the X axis disappear
        xAxis.enabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.labelTextColor = UIColor.white
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "Avenir", size: 12.0)!
        
        let leftAxis = lineChartView.rightAxis
        leftAxis.enabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        
        let rightAxis = lineChartView.leftAxis
        rightAxis.enabled = false
        rightAxis.drawGridLinesEnabled = false
        
        var entries = [ChartDataEntry]()
        
        for index in 0..<intensities.count {
            entries.append(ChartDataEntry(x: Double(index * 15), y: round(Double(intensities[index]) * 1) / 1))
        }
        
        let set = LineChartDataSet(values: entries, label: nil)
        set.highlightLineWidth = 0.0
        set.drawCircleHoleEnabled = false
        set.drawCirclesEnabled = false
        set.colors = [UIColor(red: 135, green: 135, blue: 135)]
        set.lineWidth = 5.0
        
        let data = LineChartData(dataSet: set)
        
        data.setDrawValues(false)
//        data.setValueFont(UIFont(name: "Avenir", size: 15.0))
//        data.setValueTextColor(UIColor(red: 59, green: 213, blue: 0))
        
        lineChartView.data = data
        lineChartView.notifyDataSetChanged()
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

extension UIView {
    
    // Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    
    // Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
}

