// DetailsViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// DetailsViewController - экран детализации выбранного фильма
final class DetailsViewController: UIViewController {
    // MARK: - Visual Components

    let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var detailsCollectionView: UICollectionView = {
        let layout = StreacheHeaderLayout()
        layout.scrollDirection = .vertical
        let padding = 20.0
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellid)
        collectionView.register(DescriptionCell.self, forCellWithReuseIdentifier: cellid2)
        collectionView.register(CastsCell.self, forCellWithReuseIdentifier: cellid3)
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerId
        )
        collectionView.backgroundColor = .black
        return collectionView
    }()

    let topView = UIView()
    let detailsView = UIView()
    let statusBarView = UIView()

    // MARK: - Public Properties

    var currentMovie: Result?
    var currentDetails: Details?
    var currentCasts: [Cast] = []
    var movieImage = UIImage()
    var headerView = HeaderView()
    var logo: String?
    let cellid = "cellid"
    let cellid2 = "cellid2"
    let cellid3 = "cellid3"
    let headerId = "headerId"

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupMovie()
        loadMovieData()
        loadMovieImages()
        loadCasts()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLayouts()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        headerView.animator2.stopAnimation(true)
    }

    // MARK: - Public methods

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY > 0 {
            headerView.animator2?.fractionComplete = 0
            return
        }
        headerView.animator2?.fractionComplete = abs(contentOffsetY) / 150
    }

    // MARK: - Private Methods

    private func setupViews() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        view.backgroundColor = UIColor(named: Constants.ownWhiteColor)
        UINavigationBar.appearance().barTintColor = .clear

        statusBarView.backgroundColor = .clear
        view.addSubview(detailsCollectionView)
        view.addSubview(statusBarView)

        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        statusBarView.alpha = 0
        detailsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        detailsCollectionView.contentInsetAdjustmentBehavior = .never
        NSLayoutConstraint.activate([
            detailsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            detailsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
        view.layoutIfNeeded()
    }

    private func loadCasts() {
        if let id = currentMovie?.id {
            guard let url =
                URL(
                    string: "https://api.themoviedb.org/3/movie/\(id))/credits?api_key=a24779cd5414af1e87f78fe4ff4de25c&language=en-US"
                )
            else { return }
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
                if error != nil {
                    print(error as Any)
                } else {
                    if let data = data {
                        do {
                            let res = try JSONDecoder().decode(Casts.self, from: data)
                            self.currentCasts = res.cast
                            DispatchQueue.main.async {
                                let catsInd = IndexPath(item: 2, section: 0)
                                if let castsCell = self.detailsCollectionView.cellForItem(at: catsInd) as? CastsCell {
                                    castsCell.castsCollection.reloadData()
                                }
                            }

                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }

    private func loadMovieData() {
        if let id = currentMovie?.id {
            guard let url =
                URL(
                    string: "https://api.themoviedb.org/3/movie/\(id)?api_key=a24779cd5414af1e87f78fe4ff4de25c"
                )
            else { return }
            print(url)
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
                if error != nil {
                    print(error as Any)
                } else {
                    if let data = data {
                        do {
                            let res = try JSONDecoder().decode(Details.self, from: data)
                            var genresString = ""
                            for genre in res.genres {
                                genresString += "\(genre.name)  "
                            }
                            self.currentDetails = res
                            DispatchQueue.main.async {
                                self.headerView.movieGenres.text = genresString
                                self.headerView.ratingView.rating = res.voteAverage / 2
                                let rounded = Double(round(10 * res.voteAverage) / 10)
                                let splited = res.releaseDate.split(separator: "-")
                                self.headerView.movieYear.text = "\(splited[0]) USA"
                                self.headerView.voteLabel.text = "\(rounded)"
                                let ind = IndexPath(row: 0, section: 0)
                                if let descCell = self.detailsCollectionView.cellForItem(at: ind) as? DescriptionCell {
                                    descCell.descTextLabel.text = res.overview
                                }
                                self.detailsCollectionView.reloadData()
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }

    private func loadMovieImages() {
        if let id = currentMovie?.id {
            guard let url =
                URL(
                    string: "https://api.themoviedb.org/3/movie/\(id)/images?api_key=a24779cd5414af1e87f78fe4ff4de25c"
                )
            else { return }
            print(url)
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
                if error != nil {
                    print(error as Any)
                } else {
                    if let data = data {
                        do {
                            let res = try JSONDecoder().decode(MovieImages.self, from: data)
                            if res.logos.count > 0 {
                                self.logo = res.logos[0].filePath
                                let logoUrl = "https://image.tmdb.org/t/p/w500\(res.logos[0].filePath ?? "")"
                                DispatchQueue.main.async {
                                    self.headerView.logoImage.downloaded(
                                        from: logoUrl,
                                        contentMode: .scaleAspectFit
                                    )
                                }
                            }

                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }

    private func setupMovie() {
        if let currentMovie = currentMovie {
            headerView.movieName.text = currentMovie.title
            headerView.ratingView.rating = currentMovie.voteAverage / 2
            view.layoutIfNeeded()
        }
    }

    private func setLayouts() {
        let navigationBarHeight = view.safeAreaInsets.top +
            (navigationController?.navigationBar.frame.height ?? 0.0)
        NSLayoutConstraint.activate([
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarView.heightAnchor.constraint(equalToConstant: navigationBarHeight),
            statusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        view.layoutIfNeeded()
        let gradient = CAGradientLayer()
        gradient.frame = statusBarView.frame
        gradient.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        let point4 = 0.0
        let point1 = 0.0
        let point3 = 1.0
        gradient.locations = [point4 as NSNumber, point1 as NSNumber, point3 as NSNumber]
        statusBarView.layer.insertSublayer(gradient, at: 0)

        UIView.animate(withDuration: 0.5) {
            self.statusBarView.alpha = 1
            self.headerView.movieName.alpha = 1
            self.headerView.movieGenres.alpha = 1
            self.headerView.logoImage.alpha = 1
            self.headerView.movieYear.alpha = 1
            self.headerView.movieDuration.alpha = 1
            self.headerView.timeIcon.alpha = 1
            self.headerView.voteLabel.alpha = 1
            self.headerView.ratingView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
}

/// UICollectionViewDelegate, UICollectionViewDataSource
extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.item == 0 {
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellid2,
                for: indexPath
            ) as? DescriptionCell {
                cell.backgroundColor = .black
                cell.descTextLabel.text = currentDetails?.overview
                return cell
            }

        } else if indexPath.item == 1 {
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellid3,
                for: indexPath
            ) as? CastsCell {
                cell.backgroundColor = .black
                cell.casts = currentCasts
                DispatchQueue.main.async {
                    cell.castsCollection.reloadData()
                    cell.layoutIfNeeded()
                }
                return cell
            }

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath)
            cell.backgroundColor = .black
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if let header = (collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerId,
            for: indexPath
        ) as? HeaderView) {
            headerView = header
            headerView.movieCover.image = movieImage
            return headerView
        }
        return UICollectionReusableView()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: view.frame.width, height: (collectionView.frame.height / 3) * 2)
    }
}

/// UICollectionViewDelegateFlowLayout
extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.item == 0 {
            let label = UILabel()
            label.font = UIFont(name: Constants.chilliRegular, size: 16)
            label.numberOfLines = 0
            let heightForLabel = label.heightForLabel(
                text: currentDetails?.overview ?? "",
                font: UIFont(name: Constants.chilliRegular, size: 16) ?? UIFont.systemFont(ofSize: 17),
                width: collectionView.frame.width
            )
            return CGSize(width: collectionView.frame.width - 40, height: heightForLabel + 60)
        } else if indexPath.item == 1 {
            return CGSize(width: collectionView.frame.width - 40, height: 350)
        }
        return CGSize(width: collectionView.frame.width - (2 * 20), height: 50)
    }
}

/// UILabel extension что бы подсчитать высоту при заданных шрифта и ширины лейбла
extension UILabel {
    func heightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
