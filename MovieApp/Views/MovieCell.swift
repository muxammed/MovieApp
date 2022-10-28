// MovieCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// MovieCell ячейка для отображение фильмов
final class MovieCell: UICollectionViewCell {
    // MARK: - Visual properties

    let moviePhoto: UIImageView = {
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

    // MARK: - Public methods

    func setupView() {
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.masksToBounds = true
        moviePhoto.translatesAutoresizingMaskIntoConstraints = false
        addSubview(moviePhoto)
    }

    func configure(with movie: Result) {
        moviePhoto.downloaded(
            from: "https://image.tmdb.org/t/p/w500\(movie.backdroPath)",
            contentMode: .scaleAspectFill
        )
    }

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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// UIImageView extension для скачивания фото в imageView и с настроем контент мода
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }

    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
