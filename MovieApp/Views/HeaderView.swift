// HeaderView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// HeaderView растягиваемый хеадер вьюв с блур эффектом фрактион комлит которого привязан к скролу коллектион вьюв
final class HeaderView: UICollectionReusableView {
    // MARK: - Visual components

    lazy var movieCover: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let gradientView = UIView()
    let gradient = CAGradientLayer()

    let movieName: UILabel = {
        let label = UILabel()
        label.text = "Movie Name"
        label.textColor = .white
        label.font = UIFont(name: Constants.chilliMedium, size: 40)
        label.alpha = 0
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()

    let movieGenres: UILabel = {
        let label = UILabel()
        label.text = "Action"
        label.textColor = .white
        label.font = UIFont(name: Constants.gilroyMedium, size: 14)
        label.alpha = 0
        return label
    }()

    let movieYear: UILabel = {
        let label = UILabel()
        label.text = "2022 USA"
        label.textColor = .white
        label.font = UIFont(name: Constants.gilroyMedium, size: 14)
        label.alpha = 0
        return label
    }()

    let timeIcon: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(systemName: "clock")
        label.contentMode = .scaleAspectFit
        label.clipsToBounds = true
        label.tintColor = .white
        label.alpha = 0
        return label
    }()

    let movieDuration: UILabel = {
        let label = UILabel()
        label.text = "2 h 56 min"
        label.textColor = .white
        label.font = UIFont(name: Constants.gilroyMedium, size: 14)
        label.alpha = 0
        return label
    }()

    let voteLabel: UILabel = {
        let label = UILabel()
        label.text = "8.7"
        label.textColor = .white
        label.font = UIFont(name: Constants.gilroySemibold, size: 15)
        label.alpha = 0
        return label
    }()

    lazy var ratingView: FloatRatingView = {
        let ratingView = FloatRatingView()
        ratingView.contentMode = .scaleAspectFit
        ratingView.fullImage = UIImage(named: "star")
        ratingView.emptyImage = UIImage(named: "star2")
        ratingView.maxRating = 5
        ratingView.minRating = 1
        ratingView.rating = 3
        ratingView.alpha = 0
        ratingView.backgroundColor = .clear
        ratingView.type = .floatRatings
        return ratingView
    }()

    let watchButton: UIButton = {
        let button = UIButton()
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: Constants.chilliMedium, size: 17),
            NSAttributedString.Key.foregroundColor: UIColor(named: Constants.ownDarkestColor)
        ]
        button.setAttributedTitle(NSAttributedString(string: "Watch", attributes: attrs), for: .normal)
        button.backgroundColor = UIColor(named: Constants.ownYellowColor)
        button.layer.cornerRadius = 15
        return button
    }()

    let downloadImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.down.to.line")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let bookmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bookmark")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()

    // MARK: - Public properties

    var animator2: UIViewPropertyAnimator!

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
        let gradientHeight = movieCover.frame.height / 2

        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: movieCover.leadingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: movieCover.bottomAnchor),
            gradientView.trailingAnchor.constraint(equalTo: movieCover.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: gradientHeight)
        ])

        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
        let point4 = 0.0
        let point1 = 0.3
        let point2 = 0.8
        let point3 = 1.0
        gradient.locations = [point4 as NSNumber, point2 as NSNumber, point3 as NSNumber]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }

    // MARK: - Private methods

    private func addCoverImage() {
        addSubview(movieCover)
        movieCover.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieCover.topAnchor.constraint(equalTo: topAnchor),
            movieCover.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieCover.bottomAnchor.constraint(equalTo: bottomAnchor),
            movieCover.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func addBlurEffect() {
        let visualEffectView = UIVisualEffectView()
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(visualEffectView)
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: movieCover.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: movieCover.leadingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: movieCover.bottomAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: movieCover.trailingAnchor),
        ])
        animator2 = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: { [visualEffectView] in
            visualEffectView.effect = UIBlurEffect(style: .light)
        })
    }

    private func addGradient() {
        addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.backgroundColor = .clear

        needsUpdateConstraints()
        setNeedsLayout()
    }

    private func addLogoImage() {
        addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImage.bottomAnchor.constraint(equalTo: movieName.topAnchor, constant: 18),
            logoImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3),
            logoImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3 / 4),
            logoImage.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    private func setupViews() {
        addCoverImage()
        addBlurEffect()
        addGradient()
        addSubview(movieName)
        movieName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieName.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -110)
        ])
        addSubview(movieGenres)
        movieGenres.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieGenres.topAnchor.constraint(equalTo: movieName.bottomAnchor, constant: 0),
            movieGenres.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieGenres.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        addSubview(movieYear)
        addSubview(timeIcon)
        addSubview(movieDuration)
        movieYear.translatesAutoresizingMaskIntoConstraints = false
        timeIcon.translatesAutoresizingMaskIntoConstraints = false
        movieDuration.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieYear.topAnchor.constraint(equalTo: movieGenres.bottomAnchor, constant: 5),
            movieYear.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieYear.widthAnchor.constraint(equalToConstant: 70),

            timeIcon.leadingAnchor.constraint(equalTo: movieYear.trailingAnchor, constant: 0),
            timeIcon.centerYAnchor.constraint(equalTo: movieYear.centerYAnchor),
            timeIcon.widthAnchor.constraint(equalToConstant: 14),
            timeIcon.heightAnchor.constraint(equalToConstant: 14),

            movieDuration.leadingAnchor.constraint(equalTo: timeIcon.trailingAnchor, constant: 5),
            movieDuration.centerYAnchor.constraint(equalTo: movieYear.centerYAnchor),
            movieDuration.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        voteLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(voteLabel)
        addSubview(ratingView)
        NSLayoutConstraint.activate([
            voteLabel.topAnchor.constraint(equalTo: movieYear.bottomAnchor, constant: 5),
            voteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            voteLabel.widthAnchor.constraint(equalToConstant: 25),

            ratingView.leadingAnchor.constraint(equalTo: voteLabel.trailingAnchor, constant: 0),
            ratingView.centerYAnchor.constraint(equalTo: voteLabel.centerYAnchor, constant: -2),
            ratingView.widthAnchor.constraint(equalToConstant: 80),
            ratingView.heightAnchor.constraint(equalToConstant: 14),
        ])

        addSubview(watchButton)
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            watchButton.topAnchor.constraint(equalTo: voteLabel.bottomAnchor, constant: 20),
            watchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            watchButton.heightAnchor.constraint(equalToConstant: 44),
            watchButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2 / 3),
        ])

        addSubview(downloadImage)
        addSubview(bookmarkImage)
        downloadImage.translatesAutoresizingMaskIntoConstraints = false
        bookmarkImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookmarkImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bookmarkImage.widthAnchor.constraint(equalToConstant: 44),
            bookmarkImage.heightAnchor.constraint(equalToConstant: 28),
            bookmarkImage.centerYAnchor.constraint(equalTo: watchButton.centerYAnchor),

            downloadImage.trailingAnchor.constraint(equalTo: bookmarkImage.leadingAnchor, constant: 5),
            downloadImage.widthAnchor.constraint(equalToConstant: 44),
            downloadImage.heightAnchor.constraint(equalToConstant: 28),
            downloadImage.centerYAnchor.constraint(equalTo: watchButton.centerYAnchor),

        ])

        addLogoImage()
    }

    private func makeLayout(visualEffectView: UIVisualEffectView) {
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
