//
//  ViewController.swift
//  iOSTaskCornerWearables
//
//  Created by Bálint Németh on 2018. 09. 10..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import AVFoundation

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
    var datas = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseDataFromCSV()
        parseStat()
        parseBreakdowns()
        print("ljlé")
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
    
    func parseBreakdowns() {

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

        jabLbl.text = String(jab)
        crossLbl.text = String(cross)
        rightHookLbl.text = String(rightHook)
        leftHookLbl.text = String(leftHook)
        rightUCLbl.text = String(rightUC)
        leftUCLbl.text = String(leftUC)
    }
}

