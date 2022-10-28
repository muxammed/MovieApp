// DescriptionCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// DescriptionCell - ячейка для описания
final class DescriptionCell: UICollectionViewCell {
    // MARK: - Visual components

    let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.chilliMedium, size: 20)
        label.text = "Description"
        return label
    }()

    let descTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.chilliRegular, size: 16)
        label.text = "DescriptionText"
        label.numberOfLines = 0
        return label
    }()

    // MARK: public properties

    var labelHeight = NSLayoutConstraint()

    // MARK: - Initialisators

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupViews() {
        addSubview(descLabel)
        addSubview(descTextLabel)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            descLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            descTextLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 15),
            descTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        ])
    }
}
