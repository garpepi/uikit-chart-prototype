//
//  PiechViewController.swift
//  playground-charts
//
//  Created by Garpepi Aotearoa on 24/04/24.
//

import UIKit
import Charts

class PiechViewController: UIViewController {

    @IBOutlet weak var pieView: PieChartView!
    
    let entries: [PieChartDataEntry] = [
        PieChartDataEntry(value: 1.0, label: "A", icon: UIImage(systemName: "square.and.arrow.up.circle")),
        PieChartDataEntry(value: 9.0, label: "A", icon: UIImage(systemName: "square.and.arrow.up.circle")),
        PieChartDataEntry(value: 70.0, label: "B", icon: UIImage(systemName: "square.and.arrow.up.badge.clock.fill")),
        PieChartDataEntry(value: 1.0, label: "A", icon: UIImage(systemName: "square.and.arrow.up.circle")),
        PieChartDataEntry(value: 20.0, label: "C", icon: UIImage(systemName: "rectangle.portrait.and.arrow.forward.fill")),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let set = PieChartDataSet(entries: entries, label: "Election Results")
        set.sliceSpace = 2
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        set.valueLinePart1OffsetPercentage = 0.8
        set.valueLinePart1Length = 0.2
        set.valueLinePart2Length = 0.4
        //set.xValuePosition = .outsideSlice
        set.yValuePosition = .outsideSlice
        
        let data = PieChartData(dataSet: set)
//        let data = ChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        
        pieView.data = data
        pieView.highlightValues(nil)
    }
}
