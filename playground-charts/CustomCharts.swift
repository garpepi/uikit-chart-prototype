//
//  CustomCharts.swift
//  playground-charts
//
//  Created by Garpepi Aotearoa on 16/08/23.
//

import UIKit
import Charts

/// Offset between info bubble and chart
struct InfoBubbleOffset {
    let x: CGFloat
    let y: CGFloat
}

/// Caluclates optimal offset for info bubble
struct InfoBubbleOffsetProvider {
    func getFittingOffset(
        forChild view: UIView,
        inParent parent: UIView,
        withMarker markerPosition: CGPoint,
        margin: CGFloat
    ) -> InfoBubbleOffset {
        let labelSize = view.bounds.size

        var preferredLabelCenterX = max(markerPosition.x - labelSize.width / 2 - margin, 0)
        var preferredLabelCenterY = min(markerPosition.y + labelSize.height / 2 + margin, parent.bounds.height)

        let fitsLeftBorder = preferredLabelCenterX - labelSize.width / 2 >= 0
        let fitsBottom = parent.bounds.height - preferredLabelCenterY - labelSize.height >= 0

        if !fitsLeftBorder {
            preferredLabelCenterX = markerPosition.x + labelSize.width / 2 + margin
        }

        if !fitsBottom {
            preferredLabelCenterY = markerPosition.y - labelSize.height / 2 - margin
        }

        let chartCenterX = parent.bounds.width / 2
        let chartCenterY = parent.bounds.height / 2

        let offsetX = preferredLabelCenterX - chartCenterX
        let offsetY = preferredLabelCenterY - chartCenterY

        return InfoBubbleOffset(x: offsetX, y: offsetY)
    }
}

final class CustomYAxisFormatter: AxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        print("\(value) -- \(axis)")
        let number = value / 1000
        if value < 1 {
            return String(value)
        } else {
            return "\(Int(number))K"
        }

    }
}

final class CustomXAxisFormatter: AxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        print("\(value) -- \(axis)")
        return DateFormatter().monthSymbols[Int(value)]
    }
}

/// Marker for highlighting selected value on graph
final class CircleMarker: MarkerView {
    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)
        dump("\(context)")
        dump("\(point)")
        context.setFillColor(UIColor.white.cgColor)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(2)

        let radius: CGFloat = 8
        let rectangle = CGRect(
            x: point.x - radius,
            y: point.y - radius,
            width: radius * 2,
            height: radius * 2
        )
        context.addEllipse(in: rectangle)
        context.drawPath(using: .fillStroke)
    }
}
