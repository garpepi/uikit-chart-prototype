//
//  ViewController.swift
//  playground-charts
//
//  Created by Garpepi Aotearoa on 09/08/23.
//

import UIKit
import Charts

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(ChartMiniTableViewCell.nib, forCellReuseIdentifier: ChartMiniTableViewCell.identifier)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var chartContainer: UIView!
    let chart = LineChartView()
    let circleMarker = CircleMarker()
    let infoMarker = InfoMarkerView()

    var dataSetCount = 2
    var lineChartEntries = [
        ChartDataEntry(x: 1, y: 2000), // Jan
        ChartDataEntry(x: 2, y: 4100), // Feb
        ChartDataEntry(x: 3, y: 3000),
        ChartDataEntry(x: 4, y: 3000),
        ChartDataEntry(x: 5, y: 3000),
        ChartDataEntry(x: 6, y: 12000),
    ]

    var lineChartEntries2 = [
        ChartDataEntry(x: 1, y: 1000), // Jan
        ChartDataEntry(x: 2, y: 3100), // Feb
        ChartDataEntry(x: 3, y: 2000),
        ChartDataEntry(x: 4, y: 3000),
        ChartDataEntry(x: 5, y: 1000),
        ChartDataEntry(x: 6, y: 8000),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
        // Do any additional setup after loading the view.
        chartContainer.layer.borderWidth = 1.0
        chartContainer.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.leadingAnchor.constraint(equalTo: chartContainer.leadingAnchor).isActive = true
        chart.trailingAnchor.constraint(equalTo: chartContainer.trailingAnchor).isActive = true
        chart.topAnchor.constraint(equalTo: chartContainer.topAnchor).isActive = true
        chart.bottomAnchor.constraint(equalTo: chartContainer.bottomAnchor).isActive = true
        infoMarker.isHidden = false
        lineChartEntries = makeRandomChartDataset()
        lineChartEntries2 = makeRandomChartDataset()
        setChartData()
    }

    func setTable() {
//        tableView.dataSource = self
//        tableView.delegate = self
    }

    func makeRandomChartDataset() -> [ChartDataEntry] {
        var numbers = [Double]()
        for number in 1000...10000 {
            numbers.append(Double(number) + Double(number) / 100)
        }

        var entries = [ChartDataEntry]()

        for position in 1...11 {
            if let randomValue = numbers.randomElement() {
                let entry = ChartDataEntry(
                    x: Double(position),
                    y: randomValue)
                entries.append(entry)
            }
        }

        return entries
    }

    func setDataSet(dataEntry: [ChartDataEntry], label: String, color: [UIColor]) -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: dataEntry, label: label)
        dataSet.lineWidth = 1
        dataSet.colors = color
        dataSet.mode = .horizontalBezier // curve smoothing
        dataSet.drawValuesEnabled = false // disble values
        dataSet.drawCirclesEnabled = false // disable circles
        dataSet.drawFilledEnabled = false // gradient setting
        // selected value display settings
        dataSet.drawHorizontalHighlightIndicatorEnabled = false // leave only vertical line
        dataSet.highlightLineWidth = 2 // vertical line width
        dataSet.highlightColor = .red // vertical line color
        return dataSet
    }

    func setChartData() {
        let dataSet1 = setDataSet(dataEntry: lineChartEntries, label: "Data 1", color: [.blue])
        let dataSet2 = setDataSet(dataEntry: lineChartEntries2, label: "Data 2", color: [.red])
        let data = LineChartData(dataSets: [dataSet1, dataSet2])
        let xAxis = chart.xAxis
        xAxis.valueFormatter = CustomXAxisFormatter()
        xAxis.axisMinimum = 1

        let yAxis = chart.leftAxis
        yAxis.valueFormatter = CustomYAxisFormatter()

        // disable coordinate grid
        chart.xAxis.labelPosition = .bottom
        chart.leftAxis.gridLineDashLengths = [4,4]
        chart.xAxis.gridLineDashLengths = [4,4]

        // disable legend
        chart.legend.enabled = false

        // disable zoom
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false

        // remove artifacts around chart area
        chart.rightAxis.enabled = false
        chart.minOffset = 0

        // delegate for touch handling
        chart.delegate = self

        // markers
        chart.drawMarkers = true
        circleMarker.chartView = chart
        chart.marker = circleMarker

        chart.data = data
    }

    @IBAction func dataA(_ sender: Any) {
        lineChartEntries = makeRandomChartDataset()
        lineChartEntries2 = makeRandomChartDataset()
        setChartData()
    }
    @IBAction func dataB(_ sender: Any) {
        lineChartEntries = makeRandomChartDataset()
        lineChartEntries2 = makeRandomChartDataset()
        setChartData()
    }
}

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

        // Make selected 2 Marker
        var highlightData: [Highlight] = []

        for index in 0...dataSetCount-1 {
            highlightData.append(Highlight(x: highlight.x, dataSetIndex: index, stackIndex: index))
        }
        chartView.highlightValues(highlightData)

        // Marker Info
        let markerPosition = CGPoint(x: highlight.xPx, y: highlight.yPx)
        let offsetProvider = InfoBubbleOffsetProvider()
        let fittingOffset = offsetProvider.getFittingOffset(
            forChild: infoMarker,
            inParent: chartView,
            withMarker: markerPosition,
            margin: 12.0
        )

        print("-- highlight \(highlight)")
        print("-- fitt \(fittingOffset)")

//        infoBubble.snp.updateConstraints {
//            $0.centerX.equalToSuperview().offset(fittingOffset.x)
//            $0.centerY.equalToSuperview().offset(fittingOffset.y)
//        }

        infoMarker.backgroundColor = .red
        chartView.addSubview(infoMarker)
        infoMarker.translatesAutoresizingMaskIntoConstraints = false
//        infoMarker.centerXAnchor.constraint(equalTo: chartView, constant: fittingOffset.x)
        infoMarker.frame.size.width = 100.0
        infoMarker.frame.size.height = 100.0


        infoMarker.isHidden = false
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("-- not selected")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartMiniTableViewCell.identifier) as? ChartMiniTableViewCell else { return UITableViewCell()}
        if indexPath.row == 1 {
            cell.setDown()
        } else {
            cell.lineChartEntries = [
                    ChartDataEntry(x: 1, y: 2000),
                    ChartDataEntry(x: 2, y: 4100),
                    ChartDataEntry(x: 3, y: 3000),
                    ChartDataEntry(x: 4, y: 3000),
                    ChartDataEntry(x: 5, y: 3000),
                    ChartDataEntry(x: 6, y: 12000),
            ]
        }
        cell.setChartData()
        return cell
    }


}

extension ViewController: UITableViewDelegate {

}
