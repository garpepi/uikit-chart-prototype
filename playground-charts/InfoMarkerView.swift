//
//  InfoMarkerView.swift
//  playground-charts
//
//  Created by Garpepi Aotearoa on 24/08/23.
//

import UIKit

class InfoMarkerView: UIView {
    
    let nibName = String(describing: InfoMarkerView.self)
    @IBOutlet weak var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        self.backgroundColor = .red
        contentView.fixInView(self)
    }

}
