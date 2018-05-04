//
//  ViewController.swift
//  Charts-test
//
//  Created by Sarvad shetty on 5/3/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftChart

class MainVc: UIViewController {
   
    //MARK:IBOutlets
    @IBOutlet weak var currentRateValue: UILabel!
//    @IBOutlet weak var bottomBar: Chart!
    @IBOutlet weak var chart: Chart!
    
    //MARK:Variables
    var graphDataArray:[GraphData] = []
    var values:[Double] = []
    var dates:[String] = []
    var monthLabels:[String] = []
    var monthLabelCount:[Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistoricalData()
    }

    //MARK:IBActions
    @IBAction func switched(_ sender: UISwitch) {
    }
    
    //MARK:Networking
    func getHistoricalData(){
        graphDataArray = []
        values = []
        dates = []
        Alamofire.request(URL(string:"https://api.coindesk.com/v1/bpi/historical/INR.json")!, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                print("success")
                let jsonData:JSON = JSON(response.result.value!)
                for (key,subJson):(String , JSON) in jsonData["bpi"]{
                    let graphDataObject = GraphData(x: subJson.double!, y: key)
                    self.values.append(graphDataObject.x)
                    self.dates.append(graphDataObject.y)
                    
                }
                print(self.values)
                print(self.dates)
                self.useDates(dates: self.dates,value: self.values)
            }
        }
    }
    func useDates(dates:[String],value:[Double]){
        print(dates)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for i in 0..<dates.count{
            let iosDate = dateFormatter.date(from: dates[i])
            _ = dateFormatter.string(from: iosDate!)
            let dtFormatter2 = DateFormatter()
            dtFormatter2.dateFormat = "MM"
            let month = Int(dtFormatter2.string(from: (iosDate as? Date)!))!

            let monthAsStrings:String = dtFormatter2.monthSymbols[month - 1]
            if(monthLabels.count == 0 || monthLabels.last != monthAsStrings && monthLabels.first != monthAsStrings ){
                monthLabels.append(monthAsStrings)
                monthLabelCount.append(Double(month))
            }
            let series = ChartSeries(value)
            series.color = UIColor.cyan
            series.area = true
            
            //Configure chart layout
           
            chart.lineWidth = 0.5
            chart.labelFont = UIFont.systemFont(ofSize: 12)
            chart.yLabelsOnRightSide = false
            chart.minY = value.min()! - 5
            chart.removeAllSeries()
            chart.add(series)
            
        }
    }
    
}

