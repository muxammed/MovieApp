// SearchViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// SearchViewController это будет контроллер с поиском и фильтрацией
final class SearchViewController: UIViewController {
    // MARK: - Visual Components

    private let filterView = UIView()
    private let popularButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: Constants.chilliMedium, size: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        button.setAttributedTitle(
            NSAttributedString(string: Constants.popularTitle, attributes: attrs),
            for: .normal
        )
        button.backgroundColor = UIColor(named: Constants.ownBlueColor)
        return button
    }()

    private let topRatedButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: Constants.chilliMedium, size: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        button.setAttributedTitle(
            NSAttributedString(string: Constants.topRatedTitle, attributes: attrs),
            for: .normal
        )
        button.backgroundColor = UIColor(named: Constants.ownBlueColor)
        return button
    }()

    private let upcomingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: Constants.chilliMedium, size: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        button.setAttributedTitle(
            NSAttributedString(string: Constants.upcomingTitle, attributes: attrs),
            for: .normal
        )
        button.backgroundColor = UIColor(named: Constants.ownBlueColor)
        return button
    }()

    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cv.delegate = self
        cv.dataSource = self
        cv.register(MovieViewCell.self, forCellWithReuseIdentifier: cellid)
        cv.backgroundColor = .black
        return cv
    }()

    // MARK: - Public Properties

    var currentCell: MovieViewCell?

    // MARK: - Private Properties

    let attrs = [
        NSAttributedString.Key.font: UIFont(name: Constants.chilliMedium, size: 16),
        NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    private var movies: [MovieShortDetails] = []
    private let cellid = "cellid"
    private let transitionManager = TransitionManager(duration: 0.7)
    private var loadedPage = 1

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        addTargest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavController()
    }

    // MARK: - Public methods

    @objc func loadPopularAction() {
        loadFilms(
            what: "https://api.themoviedb.org/3/movie/popular?api_key=a24779cd5414af1e87f78fe4ff4de25c&language=en-US&page=1"
        )
    }

    @objc func loadTopRatedAction() {
        loadFilms(
            what: "https://api.themoviedb.org/3/movie/top_rated?api_key=a24779cd5414af1e87f78fe4ff4de25c&language=en-US&page=1"
        )
    }

    @objc func loadUpcomingAction() {
        loadFilms(
            what: "https://api.themoviedb.org/3/movie/upcoming?api_key=a24779cd5414af1e87f78fe4ff4de25c&language=en-US&page=1"
        )
    }

    // MARK: - Private Methods

    private func setupViews() {
        navigationItem.backButtonTitle = ""
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: Constants.ownDarkestColor)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        popularButton.translatesAutoresizingMaskIntoConstraints = false
        topRatedButton.translatesAutoresizingMaskIntoConstraints = false
        upcomingButton.translatesAutoresizingMaskIntoConstraints = false

        filterView.backgroundColor = UIColor(named: Constants.ownDarkestColor)
        view.addSubview(filterView)
        filterView.addSubview(popularButton)
        filterView.addSubview(topRatedButton)
        filterView.addSubview(upcomingButton)
        view.addSubview(moviesCollectionView)
        loadFilms(
            what: "https://api.themoviedb.org/3/trending/movie/day?api_key=a24779cd5414af1e87f78fe4ff4de25c&language=en&page=\(loadedPage)"
        )
    }

    private func setupLayouts() {
        filterViewConstraints()
        topRatedButtonConstraints()
        popularButtonConstraints()
        upcomingButtonConstraints()
        moviesCollectionConstraints()
    }

    private func filterViewConstraints() {
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func topRatedButtonConstraints() {
        NSLayoutConstraint.activate([
            topRatedButton.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            topRatedButton.heightAnchor.constraint(equalToConstant: 30),
            topRatedButton.centerXAnchor.constraint(equalTo: filterView.centerXAnchor),
            topRatedButton.widthAnchor.constraint(equalToConstant: 120),
        ])
    }

    private func popularButtonConstraints() {
        NSLayoutConstraint.activate([
            popularButton.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            popularButton.heightAnchor.constraint(equalToConstant: 30),
            popularButton.trailingAnchor.constraint(equalTo: topRatedButton.leadingAnchor, constant: -10),
            popularButton.widthAnchor.constraint(equalToConstant: 120),
        ])
    }

    private func upcomingButtonConstraints() {
        NSLayoutConstraint.activate([
            upcomingButton.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            upcomingButton.heightAnchor.constraint(equalToConstant: 30),
            upcomingButton.leadingAnchor.constraint(equalTo: topRatedButton.trailingAnchor, constant: 10),
            upcomingButton.widthAnchor.constraint(equalToConstant: 120),
        ])
    }

    private func moviesCollectionConstraints() {
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: filterView.bottomAnchor),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func addTargest() {
        popularButton.addTarget(self, action: #selector(loadPopularAction), for: .touchUpInside)
        topRatedButton.addTarget(self, action: #selector(loadTopRatedAction), for: .touchUpInside)
        upcomingButton.addTarget(self, action: #selector(loadUpcomingAction), for: .touchUpInside)
    }

    private func configNavController() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.tintColor = UIColor(named: Constants.ownYellowColor)
    }

    private func loadFilms(what: String) {
        guard let url =

            URL(
                string: what
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
                        let res = try JSONDecoder().decode(MovieListResponse.self, from: data)
                        self.movies = res.results
                        DispatchQueue.main.async {
                            self.moviesCollectionView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }

    private func goToDetails(with indexPath: IndexPath) {
        if let currentCell = moviesCollectionView.cellForItem(at: indexPath) as? MovieViewCell {
            self.currentCell = currentCell
            navigationController?.delegate = transitionManager
            let detailsViewController = DetailsViewController()
            detailsViewController.movieImage = currentCell.getMoviePhotoImageView().image ?? UIImage()
            detailsViewController.currentMovie = movies[indexPath.item]
            navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
}

/// UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellid,
            for: indexPath
        ) as? MovieViewCell
        else { return UICollectionViewCell() }
        cell.configure(with: movies[indexPath.row])
        cell.backgroundColor = .white
        currentCell = cell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToDetails(with: indexPath)
    }
}

/// UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: (view.frame.width - 40) / 3, height: 150)
    }
}
