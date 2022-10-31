// MovieViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// MovieCell ячейка для отображение фильмов
final class MovieViewCell: UICollectionViewCell {
    // MARK: - Visual properties

    private let moviePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    // MARK: - Initializators

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        NSLayoutConstraint.activate([
            moviePhoto.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            moviePhoto.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            moviePhoto.bottomAnchor.constraint(equalTo: bottomAnchor),
            moviePhoto.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
    }

    public func getMoviePhotoImageView() -> UIImageView {
        moviePhoto
    }

    // MARK: - Private methods

    private func setupView() {
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.masksToBounds = true
        moviePhoto.translatesAutoresizingMaskIntoConstraints = false
        addSubview(moviePhoto)
    }

    func configure(with movie: MovieShortDetails) {
        moviePhoto.downloaded(
            from: "https://image.tmdb.org/t/p/w500\(movie.backdroPath)",
            contentMode: .scaleAspectFill
        )
    }
}
