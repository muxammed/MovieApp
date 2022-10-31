// CastsCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// CastsCell ячейка для списка актеров внутри себя имеет также коллекшн вьюв
final class CastsCell: UICollectionViewCell {
    // MARK: - Visual components

    private let castLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.chilliMedium, size: 20)
        label.text = Constants.castsText
        return label
    }()

    private let viewAllLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.chilliRegular, size: 16)
        label.text = Constants.viewAllText
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()

    private lazy var castsCollectionView: UICollectionView = {
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

    private let cellid = "cellid"
    private var casts: [Cast] = []

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

    public func configure(with casts: [Cast]) {
        backgroundColor = .black
        self.casts = casts
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.castsCollectionView.reloadData()
            self.layoutIfNeeded()
        }
    }

    public func reloadCollectionView() {
        castsCollectionView.reloadData()
    }

    // MARK: - private methods

    private func setupViews() {
        addSubview(castLabel)
        addSubview(viewAllLabel)
        addSubview(castsCollectionView)
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        viewAllLabel.translatesAutoresizingMaskIntoConstraints = false
        castsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        castsCollectionView.backgroundColor = .black

        castLabelConstraints()
        viewAllLabelConstraints()
        castsCollectionViewConstraints()
    }

    private func castLabelConstraints() {
        NSLayoutConstraint.activate([
            castLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            castLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            castLabel.widthAnchor.constraint(equalTo: viewAllLabel.widthAnchor),
        ])
    }

    private func viewAllLabelConstraints() {
        NSLayoutConstraint.activate([
            viewAllLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewAllLabel.centerYAnchor.constraint(equalTo: castLabel.centerYAnchor),
        ])
    }

    private func castsCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            castsCollectionView.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 2),
            castsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            castsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            castsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
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
            cell.configure(with: casts[indexPath.item])
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
