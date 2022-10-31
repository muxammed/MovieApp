// UIView+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// extensions for UIView
extension UIView {
    func makeGradient(from: UIColor, to: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [to.cgColor, from.cgColor, to.cgColor, to.cgColor]
        let point4 = 0.0
        let point1 = 0.3
        let point2 = 0.9
        let point3 = 1.0
        gradient.locations = [point4 as NSNumber, point1 as NSNumber, point2 as NSNumber, point3 as NSNumber]

        layer.insertSublayer(gradient, at: 0)
    }
}
