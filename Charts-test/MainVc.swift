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
import UICountingLabel

class MainVc: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    //MARK:IBOutlets
    @IBOutlet weak var currentValue: UICountingLabel!
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var tw: UITableView!
    @IBOutlet weak var changeButton: UIButton!
    
    //MARK:Variables
    var graphDataArray:[GraphData] = []
    var values:[Double] = []
    var dates:[String] = []
    var monthLabels:[String] = []
    var monthLabelCount:[Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistoricalData()
        getCurrentData()
        changeButton.setTitle("CNY", for: .normal)
        tw.separatorStyle = .none
        
    }

    //MARK:IBActions
    @IBAction func switched(_ sender: UIButton) {
        
        if changeButton.titleLabel?.text == "INR"{
            changeButton.setTitle("CNY", for: .normal)
            getHistoricalData(cn: "INR")
            getCurrentData(cn: "INR")
            
        }else{
            changeButton.setTitle("INR", for: .normal)
            getHistoricalData(cn: "CNY")
            getCurrentData(cn: "CNY")
        }
        
    }
    
    //MARK:Networking
    func getHistoricalData(cn:String="INR"){
        graphDataArray = []
        values = []
        dates = []
        Alamofire.request(URL(string:"https://api.coindesk.com/v1/bpi/historical/close.json?currency=\(cn)")!, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                let jsonData:JSON = JSON(response.result.value!)
                for (key,subJson):(String , JSON) in jsonData["bpi"]{
                    let graphDataObject = GraphData(x: subJson.double!, y: key)
                    self.values.append(graphDataObject.x)
                    self.dates.append(graphDataObject.y)
                }
                print(self.values)
                print(self.dates)
                self.useDates(dates: self.dates,value: self.values)
                self.tw.reloadData()
            }
        }
    }
    func useDates(dates:[String],value:[Double]){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for i in 0..<dates.count{
            let iosDate = dateFormatter.date(from: dates[i])
            _ = dateFormatter.string(from: iosDate!)
            let dtFormatter2 = DateFormatter()
            dtFormatter2.dateFormat = "MM"
            let month = Int(dtFormatter2.string(from: (iosDate)!))!
            let monthAsStrings:String = dtFormatter2.monthSymbols[month - 1]
            if(monthLabels.count == 0 || monthLabels.last != monthAsStrings && monthLabels.first != monthAsStrings ){
                monthLabels.append(monthAsStrings)
                monthLabelCount.append(Double(month))
            }
            let series = ChartSeries(value)
            series.color = UIColor.cyan
            series.area = true
            
            //Configure chart layout
            chart.lineWidth = 1
            chart.labelFont = UIFont.systemFont(ofSize: 12)
            chart.yLabelsOnRightSide = false
            chart.minY = value.min()! - 5
            chart.removeAllSeries()
            chart.add(series)
            
        }
    }
    func getCurrentData(cn:String = "INR"){
        print("hi!")
        Alamofire.request("https://api.coindesk.com/v1/bpi/currentprice/\(cn).json", method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                  let jsonData:JSON = JSON(response.result.value!)
                print(jsonData["bpi"]["\(cn)"]["rate_float"].floatValue)
                let floatData = jsonData["bpi"]["\(cn)"]["rate_float"].floatValue
                self.currentValue.method = .linear
                self.currentValue.format = "%.2f%"
                self.currentValue.countFromZero(to: CGFloat(floatData))
            }
        }
    }
    
    //MARK:Table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DataTableViewCell
            cell.date.text = dates[indexPath.row]
            cell.value.method = .linear
            cell.value.format = "%.3.f%"
            cell.value.countFromCurrentValue(to: CGFloat(values[indexPath.row]))
        return cell
    }
    
    
}

