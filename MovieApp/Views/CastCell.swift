// CastCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// CastCell ячейка для вывода данных актеров
final class CastCell: UICollectionViewCell {
    // MARK: - Visual components

    let castImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(named: Constants.ownDarkColor)
        return imageView
    }()

    let castName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.chilliMedium, size: 15)
        label.numberOfLines = 0
        return label
    }()

    let castCharacter: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ownAk")
        label.font = UIFont(name: Constants.chilliRegular, size: 12)
        label.numberOfLines = 0
        return label
    }()

    let centeredView = UIView()

    // MARK: - Initialisators

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    override func layoutSubviews() {
        super.layoutSubviews()
        castImage.layer.cornerRadius = castImage.frame.height / 2
    }

    // MARK: - Private methods

    private func setupViews() {
        castImage.translatesAutoresizingMaskIntoConstraints = false
        castName.translatesAutoresizingMaskIntoConstraints = false
        castCharacter.translatesAutoresizingMaskIntoConstraints = false
        centeredView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(castImage)
        addSubview(centeredView)
        centeredView.addSubview(castName)
        centeredView.addSubview(castCharacter)

        NSLayoutConstraint.activate([
            castImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            castImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            castImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 2.5),
            castImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 2.5),

            centeredView.centerYAnchor.constraint(equalTo: castImage.centerYAnchor),
            centeredView.leadingAnchor.constraint(equalTo: castImage.trailingAnchor, constant: 5),
            centeredView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),

            castName.topAnchor.constraint(equalTo: centeredView.topAnchor),
            castName.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor),
            castName.trailingAnchor.constraint(equalTo: centeredView.trailingAnchor),

            castCharacter.topAnchor.constraint(equalTo: castName.bottomAnchor),
            castCharacter.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor),
            castCharacter.bottomAnchor.constraint(equalTo: centeredView.bottomAnchor),
            castCharacter.trailingAnchor.constraint(equalTo: centeredView.trailingAnchor)
        ])
    }
}
