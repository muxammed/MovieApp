// SearchViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// SearchViewController это будет контроллер с поиском и фильтрацией
final class SearchViewController: UIViewController {
    // MARK: - Visual Components

    let filterView = UIView()
    let buttonOne: UIButton = {
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

    let buttonDwa: UIButton = {
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

    let buttonTri: UIButton = {
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

    lazy var moviesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cv.delegate = self
        cv.dataSource = self
        cv.register(MovieCell.self, forCellWithReuseIdentifier: cellid)
        cv.backgroundColor = .black
        return cv
    }()

    // MARK: - Public Properties

    var movies: [Result] = []
    let cellid = "cellid"
    var currentCell: MovieCell?
    let transitionManager = TransitionManager(duration: 0.7)
    var loadedPage = 1

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

    @objc func loadOne() {
        loadFilms(
            what: "https://api.themoviedb.org/3/movie/popular?api_key=a24779cd5414af1e87f78fe4ff4de25c&language=en-US&page=1"
        )
    }

    @objc func loadDwa() {
        loadFilms(
            what: "https://api.themoviedb.org/3/movie/top_rated?api_key=a24779cd5414af1e87f78fe4ff4de25c&language=en-US&page=1"
        )
    }

    @objc func loadTri() {
        loadFilms(
            what: "https://api.themoviedb.org/3/movie/upcoming?api_key=a24779cd5414af1e87f78fe4ff4de25c&language=en-US&page=1"
        )
    }

    // MARK: - Private Methods

    private func setupViews() {
        navigationItem.backButtonTitle = ""
        moviesCollection.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: Constants.ownDarkestColor)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        buttonOne.translatesAutoresizingMaskIntoConstraints = false
        buttonDwa.translatesAutoresizingMaskIntoConstraints = false
        buttonTri.translatesAutoresizingMaskIntoConstraints = false

        filterView.backgroundColor = UIColor(named: Constants.ownDarkestColor)
        view.addSubview(filterView)
        filterView.addSubview(buttonOne)
        filterView.addSubview(buttonDwa)
        filterView.addSubview(buttonTri)
        view.addSubview(moviesCollection)
        loadFilms(
            what: "https://api.themoviedb.org/3/trending/movie/day?api_key=a24779cd5414af1e87f78fe4ff4de25c&language=en&page=\(loadedPage)"
        )
    }

    private func setupLayouts() {
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 50),

            buttonDwa.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            buttonDwa.heightAnchor.constraint(equalToConstant: 30),
            buttonDwa.centerXAnchor.constraint(equalTo: filterView.centerXAnchor),
            buttonDwa.widthAnchor.constraint(equalToConstant: 120),

            buttonOne.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            buttonOne.heightAnchor.constraint(equalToConstant: 30),
            buttonOne.trailingAnchor.constraint(equalTo: buttonDwa.leadingAnchor, constant: -10),
            buttonOne.widthAnchor.constraint(equalToConstant: 120),

            buttonTri.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            buttonTri.heightAnchor.constraint(equalToConstant: 30),
            buttonTri.leadingAnchor.constraint(equalTo: buttonDwa.trailingAnchor, constant: 10),
            buttonTri.widthAnchor.constraint(equalToConstant: 120),

            moviesCollection.topAnchor.constraint(equalTo: filterView.bottomAnchor),
            moviesCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            moviesCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func addTargest() {
        buttonOne.addTarget(self, action: #selector(loadOne), for: .touchUpInside)
        buttonDwa.addTarget(self, action: #selector(loadDwa), for: .touchUpInside)
        buttonTri.addTarget(self, action: #selector(loadTri), for: .touchUpInside)
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
        print(url)
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
                            self.moviesCollection.reloadData()
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

/// UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as? MovieCell
        else { return UICollectionViewCell() }
        cell.configure(with: movies[indexPath.row])
        cell.backgroundColor = .white
        currentCell = cell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentCell = moviesCollection.cellForItem(at: indexPath) as? MovieCell {
            self.currentCell = currentCell
            navigationController?.delegate = transitionManager
            let detailsViewController = DetailsViewController()
            detailsViewController.movieImage = currentCell.moviePhoto.image ?? UIImage()
            detailsViewController.currentMovie = movies[indexPath.item]
            navigationController?.pushViewController(detailsViewController, animated: true)
        }
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
