//
//  ChartMiniTableViewCell.swift
//  playground-charts
//
//  Created by Garpepi Aotearoa on 24/08/23.
//

import UIKit
import Charts

class ChartMiniTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: UIView!

    static let identifier = String(describing: ChartMiniTableViewCell.self)
    static let nib = UINib(
        nibName: identifier,
        bundle: nil)

    let chart = LineChartView()
    var isDown = false

    var lineChartEntries: [ChartDataEntry] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chartView.layer.borderWidth = 1.0
        chartView.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.leadingAnchor.constraint(equalTo: chartView.leadingAnchor).isActive = true
        chart.trailingAnchor.constraint(equalTo: chartView.trailingAnchor).isActive = true
        chart.topAnchor.constraint(equalTo: chartView.topAnchor).isActive = true
        chart.bottomAnchor.constraint(equalTo: chartView.bottomAnchor).isActive = true
        setChartData()
    }

    func setDown() {
        isDown = true
        lineChartEntries = [
            ChartDataEntry(x: 1, y: 2000),
            ChartDataEntry(x: 2, y: 4100),
            ChartDataEntry(x: 3, y: -3000),
            ChartDataEntry(x: 4, y: -4000),
            ChartDataEntry(x: 5, y: -6000),
            ChartDataEntry(x: 6, y: -12000),
        ]
    }

    func setDataSet(dataEntry: [ChartDataEntry], label: String, color: [UIColor]) -> LineChartDataSet {
        var colorAsset = UIColor(red: 56/255, green: 58/255, blue: 209/255, alpha: 1)
        if isDown {
            colorAsset = .gray
        }

        let dataSet = LineChartDataSet(entries: dataEntry, label: label)
        // chart main settings
        dataSet.setColor(colorAsset)
        dataSet.lineWidth = 1
        dataSet.mode = .cubicBezier // curve smoothing
        dataSet.drawValuesEnabled = false // disble values
        dataSet.drawCirclesEnabled = false // disable circles
        dataSet.drawFilledEnabled = true // gradient setting

        // settings for picking values on graph
        dataSet.drawHorizontalHighlightIndicatorEnabled = false // leave only vertical line

        let mainColor = colorAsset.withAlphaComponent(0.5)
        let secondaryColor = colorAsset.withAlphaComponent(0)
        let colors = [
            mainColor.cgColor,
            secondaryColor.cgColor,
            secondaryColor.cgColor
        ] as CFArray
        let locations: [CGFloat] = [1, 1, 1]
        if let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors,
            locations: locations
        ) {
            dataSet.fill = LinearGradientFill(gradient: gradient, angle: 270)
        }

        return dataSet
    }

    func setChartData() {
        let dataSet1 = setDataSet(dataEntry: lineChartEntries, label: "Data 1", color: [.blue])
        let data = LineChartData(dataSets: [dataSet1])

        chart.highlightPerTapEnabled = false
        chart.highlightPerDragEnabled = false
        // disable coordinate grid
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.drawGridBackgroundEnabled = false
        // disable labels
        chart.xAxis.drawLabelsEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        // disable legend
        chart.legend.enabled = false
        // disable zoom
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        // remove artifacts around chart area
        chart.xAxis.enabled = false
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.drawBordersEnabled = false
        chart.minOffset = 0

        chart.data = data
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
