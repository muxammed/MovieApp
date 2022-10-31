// HeaderView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// HeaderView растягиваемый хеадер вьюв с блур эффектом фрактион комлит которого привязан к скролу коллектион вьюв
final class HeaderView: UICollectionReusableView {
    // MARK: - Visual components

    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.chilliMedium, size: 40)
        label.alpha = 0
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()

    private let movieGenresLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.gilroyMedium, size: 14)
        label.alpha = 0
        return label
    }()

    private let movieYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.gilroyMedium, size: 14)
        label.alpha = 0
        return label
    }()

    private let timeIconImageView: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(systemName: Constants.clockImageName)
        label.contentMode = .scaleAspectFit
        label.clipsToBounds = true
        label.tintColor = .white
        label.alpha = 0
        return label
    }()

    private let movieDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.gilroyMedium, size: 14)
        label.alpha = 0
        return label
    }()

    private let voteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.gilroySemibold, size: 15)
        label.alpha = 0
        return label
    }()

    private lazy var ratingView: FloatRatingView = {
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

    private let watchButton: UIButton = {
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

    private let downloadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.down.to.line")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let bookmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bookmark")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()

    // MARK: - Public Properties

    public lazy var movieCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Private properties

    private var propertyAnimator: UIViewPropertyAnimator!

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
        setupGradientView()
    }

    public func setAnimationFraction(value: CGFloat) {
        propertyAnimator.fractionComplete = value
    }

    public func stopAnimation(value: Bool) {
        propertyAnimator.stopAnimation(value)
    }

    public func setupValues(with data: MovieDetails) {
        var genresString = ""
        for genre in data.genres {
            genresString += "\(genre.name)  "
        }
        movieGenresLabel.text = genresString
        ratingView.rating = data.voteAverage / 2
        let rounded = Double(round(10 * data.voteAverage) / 10)
        let splited = data.releaseDate.split(separator: "-")
        movieYearLabel.text = "\(splited[0]) USA"
        voteLabel.text = "\(rounded)"
    }

    public func setDownloadImageUrl(imageUrl: String) {
        logoImageView.downloaded(
            from: imageUrl,
            contentMode: .scaleAspectFit
        )
    }

    public func setupTextValues(movie: MovieShortDetails) {
        movieNameLabel.text = movie.title
        ratingView.rating = movie.voteAverage / 2
    }

    public func setAlpha(to: CGFloat) {
        movieNameLabel.alpha = to
        movieGenresLabel.alpha = to
        logoImageView.alpha = to
        movieYearLabel.alpha = to
        movieDurationLabel.alpha = to
        timeIconImageView.alpha = to
        voteLabel.alpha = to
        ratingView.alpha = to
    }

    // MARK: - Private methods

    private func setupGradientView() {
        let gradientHeight = movieCoverImageView.frame.height / 2

        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: movieCoverImageView.leadingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: movieCoverImageView.bottomAnchor),
            gradientView.trailingAnchor.constraint(equalTo: movieCoverImageView.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: gradientHeight)
        ])

        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
        let point4 = 0.0
        let point2 = 0.8
        let point3 = 1.0
        gradientLayer.locations = [point4 as NSNumber, point2 as NSNumber, point3 as NSNumber]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func addCoverImage() {
        addSubview(movieCoverImageView)
        movieCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieCoverImageView.topAnchor.constraint(equalTo: topAnchor),
            movieCoverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieCoverImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            movieCoverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func addBlurEffect() {
        let visualEffectView = UIVisualEffectView()
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(visualEffectView)
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: movieCoverImageView.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: movieCoverImageView.leadingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: movieCoverImageView.bottomAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: movieCoverImageView.trailingAnchor),
        ])
        propertyAnimator = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: { [visualEffectView] in
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
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.bottomAnchor.constraint(equalTo: movieNameLabel.topAnchor, constant: 18),
            logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3),
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3 / 4),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    private func setupMovieNameLabel() {
        addSubview(movieNameLabel)
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -110)
        ])
    }

    private func setupMovieGenresLabel() {
        addSubview(movieGenresLabel)
        movieGenresLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieGenresLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 0),
            movieGenresLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieGenresLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func setupMovieYearDurationLabels() {
        addSubview(movieYearLabel)
        addSubview(timeIconImageView)
        addSubview(movieDurationLabel)
        movieYearLabel.translatesAutoresizingMaskIntoConstraints = false
        timeIconImageView.translatesAutoresizingMaskIntoConstraints = false
        movieDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieYearLabel.topAnchor.constraint(equalTo: movieGenresLabel.bottomAnchor, constant: 5),
            movieYearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieYearLabel.widthAnchor.constraint(equalToConstant: 70),

            timeIconImageView.leadingAnchor.constraint(equalTo: movieYearLabel.trailingAnchor, constant: 0),
            timeIconImageView.centerYAnchor.constraint(equalTo: movieYearLabel.centerYAnchor),
            timeIconImageView.widthAnchor.constraint(equalToConstant: 14),
            timeIconImageView.heightAnchor.constraint(equalToConstant: 14),

            movieDurationLabel.leadingAnchor.constraint(equalTo: timeIconImageView.trailingAnchor, constant: 5),
            movieDurationLabel.centerYAnchor.constraint(equalTo: movieYearLabel.centerYAnchor),
            movieDurationLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupVoteRatingViews() {
        voteLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(voteLabel)
        addSubview(ratingView)
        NSLayoutConstraint.activate([
            voteLabel.topAnchor.constraint(equalTo: movieYearLabel.bottomAnchor, constant: 5),
            voteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            voteLabel.widthAnchor.constraint(equalToConstant: 25),

            ratingView.leadingAnchor.constraint(equalTo: voteLabel.trailingAnchor, constant: 0),
            ratingView.centerYAnchor.constraint(equalTo: voteLabel.centerYAnchor, constant: -2),
            ratingView.widthAnchor.constraint(equalToConstant: 80),
            ratingView.heightAnchor.constraint(equalToConstant: 14),
        ])
    }

    private func setupWatchButton() {
        addSubview(watchButton)
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            watchButton.topAnchor.constraint(equalTo: voteLabel.bottomAnchor, constant: 20),
            watchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            watchButton.heightAnchor.constraint(equalToConstant: 44),
            watchButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2 / 3),
        ])
    }

    private func setupDownloadBookmarkImageViews() {
        addSubview(downloadImageView)
        addSubview(bookmarkImageView)
        downloadImageView.translatesAutoresizingMaskIntoConstraints = false
        bookmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: 44),
            bookmarkImageView.heightAnchor.constraint(equalToConstant: 28),
            bookmarkImageView.centerYAnchor.constraint(equalTo: watchButton.centerYAnchor),

            downloadImageView.trailingAnchor.constraint(equalTo: bookmarkImageView.leadingAnchor, constant: 5),
            downloadImageView.widthAnchor.constraint(equalToConstant: 44),
            downloadImageView.heightAnchor.constraint(equalToConstant: 28),
            downloadImageView.centerYAnchor.constraint(equalTo: watchButton.centerYAnchor),

        ])
    }

    private func setupViews() {
        addCoverImage()
        addBlurEffect()
        addGradient()
        setupMovieNameLabel()
        setupMovieGenresLabel()
        setupMovieYearDurationLabels()
        setupVoteRatingViews()
        setupWatchButton()
        setupDownloadBookmarkImageViews()
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
