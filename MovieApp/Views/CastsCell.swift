// CastsCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// CastsCell ячейка для списка актеров внутри себя имеет также коллекшн вьюв
final class CastsCell: UICollectionViewCell {
    // MARK: - Visual components

    let castLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.chilliMedium, size: 20)
        label.text = Constants.castsText
        return label
    }()

    let viewAllLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.chilliRegular, size: 16)
        label.text = Constants.viewAllText
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()

    lazy var castsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CastCell.self, forCellWithReuseIdentifier: cellid)
        return collectionView
    }()

    // MARK: - Public properties

    let cellid = "cellid"
    var casts: [Cast] = []

    // MARK: - Initialisators

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private methods

    func setupViews() {
        addSubview(castLabel)
        addSubview(viewAllLabel)
        addSubview(castsCollection)
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        viewAllLabel.translatesAutoresizingMaskIntoConstraints = false
        castsCollection.translatesAutoresizingMaskIntoConstraints = false

        castsCollection.backgroundColor = .black

        NSLayoutConstraint.activate([
            castLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            castLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            castLabel.widthAnchor.constraint(equalTo: viewAllLabel.widthAnchor),

            viewAllLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewAllLabel.centerYAnchor.constraint(equalTo: castLabel.centerYAnchor),

            castsCollection.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 2),
            castsCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            castsCollection.bottomAnchor.constraint(equalTo: bottomAnchor),
            castsCollection.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

/// UICollectionViewDelegate, UICollectionViewDataSource
extension CastsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        casts.count >= 6 ? 6 : casts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as? CastCell {
            cell.castName.text = casts[indexPath.item].name
            cell.castCharacter.text = casts[indexPath.item].character
            cell.castImage.downloaded(
                from: "https://image.tmdb.org/t/p/w500\(casts[indexPath.item].profilePath ?? "")",
                contentMode: .scaleAspectFill
            )
            return cell
        }
        return UICollectionViewCell()
    }
}

/// UICollectionViewDelegateFlowLayout
extension CastsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: (collectionView.frame.width - 10) / 2, height: 90)
    }
}
