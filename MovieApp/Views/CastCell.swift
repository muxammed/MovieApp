// CastCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// CastCell ячейка для вывода данных актеров
final class CastCell: UICollectionViewCell {
    // MARK: - Visual components

    private let castImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(named: Constants.ownDarkColor)
        return imageView
    }()

    private let castNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.chilliMedium, size: 15)
        label.numberOfLines = 0
        return label
    }()

    private let castCharacterLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ownAk")
        label.font = UIFont(name: Constants.chilliRegular, size: 12)
        label.numberOfLines = 0
        return label
    }()

    private let centeredView = UIView()

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

    func configure(with cast: Cast) {
        castNameLabel.text = cast.name
        castCharacterLabel.text = cast.character
        castImageView.downloaded(
            from: "https://image.tmdb.org/t/p/w500\(cast.profilePath ?? "")",
            contentMode: .scaleAspectFill
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        castImageView.layer.cornerRadius = castImageView.frame.height / 2
    }

    // MARK: - Private methods

    private func setupViews() {
        castImageView.translatesAutoresizingMaskIntoConstraints = false
        castNameLabel.translatesAutoresizingMaskIntoConstraints = false
        castCharacterLabel.translatesAutoresizingMaskIntoConstraints = false
        centeredView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(castImageView)
        addSubview(centeredView)
        centeredView.addSubview(castNameLabel)
        centeredView.addSubview(castCharacterLabel)

        castImageViewConstraints()
        centeredViewConstraints()
        castNameLabelConstraints()
        castCharacterLabelConstraints()
    }

    private func castImageViewConstraints() {
        NSLayoutConstraint.activate([
            castImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            castImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            castImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 2.5),
            castImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 2.5),
        ])
    }

    private func centeredViewConstraints() {
        NSLayoutConstraint.activate([
            centeredView.centerYAnchor.constraint(equalTo: castImageView.centerYAnchor),
            centeredView.leadingAnchor.constraint(equalTo: castImageView.trailingAnchor, constant: 5),
            centeredView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
        ])
    }

    private func castNameLabelConstraints() {
        NSLayoutConstraint.activate([
            castNameLabel.topAnchor.constraint(equalTo: centeredView.topAnchor),
            castNameLabel.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor),
            castNameLabel.trailingAnchor.constraint(equalTo: centeredView.trailingAnchor),
        ])
    }

    private func castCharacterLabelConstraints() {
        NSLayoutConstraint.activate([
            castCharacterLabel.topAnchor.constraint(equalTo: castNameLabel.bottomAnchor),
            castCharacterLabel.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor),
            castCharacterLabel.bottomAnchor.constraint(equalTo: centeredView.bottomAnchor),
            castCharacterLabel.trailingAnchor.constraint(equalTo: centeredView.trailingAnchor)
        ])
    }
}
