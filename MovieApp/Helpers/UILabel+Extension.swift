// UILabel+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// UILabel extension что бы подсчитать высоту при заданных шрифта и ширины лейбла
extension UILabel {
    func heightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
