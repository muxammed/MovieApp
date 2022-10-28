// IntroViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// IntroViewController контроллер онбоардинга
final class IntroViewController: UIViewController {
    // MARK: - Visual Components

    let backView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: Constants.introBack)
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()

    let moveNext: UIButton = {
        let button = UIButton()
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: Constants.chilliBold, size: 15),
            NSAttributedString.Key.foregroundColor: UIColor(named: Constants.ownDarkestColor)
        ]
        button.setAttributedTitle(NSAttributedString(string: Constants.nextText, attributes: attrs), for: .normal)
        button.backgroundColor = UIColor(named: Constants.ownYellowColor)
        button.setTitleColor(UIColor(named: Constants.ownDarkestColor), for: .normal)
        button.layer.cornerRadius = 17
        return button
    }()

    let darkView: UIView = {
        let view = UIView()
        view.makeGradient(from: .black, to: .clear)
        return view
    }()

    let onboardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.chilliMedium, size: 24)
        label.textColor = .white
        label.text = Constants.firstBoardText
        return label
    }()

    let onboardSubLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.chilliRegular, size: 16)
        label.textColor = .white
        label.text = Constants.firstBoardSubText
        label.numberOfLines = 2
        return label
    }()

    let appTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.chilliBold, size: 42)
        label.textColor = UIColor(named: Constants.ownYellowColor)
        label.text = Constants.appTitle
        label.textAlignment = .center
        return label
    }()

    let appSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.chilliBold, size: 30)
        label.textColor = .white
        label.text = Constants.appSubTitle
        label.textAlignment = .center
        return label
    }()

    // MARK: - Public Properties

    var currentPage = 0
    var backTopAnchor = NSLayoutConstraint()
    var backLeadingAnchor = NSLayoutConstraint()
    var darkViewHeight = NSLayoutConstraint()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for subView in darkView.subviews {
            subView.alpha = 0
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layoutSetup()
    }

    // MARK: - Public methods

    @objc func moveNextAction() {
        if currentPage <= 1 {
            backLeadingAnchor.constant -= view.frame.width
            backTopAnchor.constant -= (view.frame.width)
            darkViewHeight.constant = -(view.frame.height)

            UIView.animate(
                withDuration: 0.7,
                delay: 0.1,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.2,
                options: .curveEaseIn
            ) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                print("animation completed")
            }
            currentPage += 1
            changeTextAction()
        } else if currentPage == 2 {
            let searchViewController = SearchViewController()
            navigationController?.pushViewController(searchViewController, animated: true)
        }
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            moveBackAction()
        } else if gesture.direction == .left {
            moveNextAction()
        }
    }

    // MARK: - Private Methods

    private func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    private func setupView() {
        view.backgroundColor = UIColor(named: Constants.ownDarkerColor)
        view.addSubview(backView)
        view.addSubview(darkView)
        darkView.addSubview(moveNext)
        darkView.addSubview(onboardLabel)
        darkView.addSubview(onboardSubLabel)
        darkView.addSubview(appTitleLabel)
        darkView.addSubview(appSubTitleLabel)

        for subView in view.subviews {
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        for subView in darkView.subviews {
            subView.translatesAutoresizingMaskIntoConstraints = false
        }

        moveNext.addTarget(self, action: #selector(moveNextAction), for: .touchUpInside)
    }

    private func moveBackAction() {
        if currentPage >= 1 {
            backLeadingAnchor.constant += view.frame.width
            backTopAnchor.constant += (view.frame.width)

            UIView.animate(
                withDuration: 0.7,
                delay: 0.1,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.2,
                options: .curveEaseIn
            ) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                print("bitti")
            }
            currentPage -= 1

            changeTextAction()
        }
    }

    private func changeTextAction() {
        UIView.animate(withDuration: 0.3) {
            self.onboardLabel.alpha = 0
            self.onboardSubLabel.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            switch self.currentPage {
            case 0:
                self.onboardLabel.text = Constants.firstBoardText
                self.onboardSubLabel.text = Constants.firstBoardSubText
            case 1:
                self.onboardLabel.text = Constants.secondBoardText
                self.onboardSubLabel.text = Constants.secondBoardSubText
            case 2:
                self.onboardLabel.text = Constants.thirdBoardText
                self.onboardSubLabel.text = Constants.thirdBoardSubText
            default:
                break
            }
            UIView.animate(withDuration: 0.3) {
                self.onboardLabel.alpha = 1
                self.onboardSubLabel.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }

    private func layoutSetup() {
        moveNext.translatesAutoresizingMaskIntoConstraints = false

        let backWidth = view.frame.width * 3
        let backHeight = view.frame.height + (view.frame.width * 2)
        backTopAnchor = backView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.width)
        backLeadingAnchor = backView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width)
        darkViewHeight = darkView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -(view.frame.height))
        NSLayoutConstraint.activate([
            backTopAnchor,
            backLeadingAnchor,
            backView.widthAnchor.constraint(equalToConstant: backWidth),
            backView.heightAnchor.constraint(equalToConstant: backHeight),
            moveNext.trailingAnchor.constraint(equalTo: darkView.trailingAnchor, constant: -30),
            moveNext.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: -50),
            moveNext.widthAnchor.constraint(equalToConstant: 100),
            moveNext.heightAnchor.constraint(equalToConstant: 34),

            darkView.topAnchor.constraint(equalTo: view.topAnchor),
            darkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            darkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            darkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            onboardLabel.leadingAnchor.constraint(equalTo: darkView.leadingAnchor, constant: 16),
            onboardLabel.trailingAnchor.constraint(equalTo: darkView.trailingAnchor, constant: -16),
            onboardLabel.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: -140),

            onboardSubLabel.topAnchor.constraint(equalTo: onboardLabel.bottomAnchor, constant: 4),
            onboardSubLabel.leadingAnchor.constraint(equalTo: darkView.leadingAnchor, constant: 16),
            onboardSubLabel.trailingAnchor.constraint(equalTo: darkView.trailingAnchor, constant: -16),

            appTitleLabel.topAnchor.constraint(equalTo: darkView.topAnchor, constant: 60),
            appTitleLabel.leadingAnchor.constraint(equalTo: darkView.leadingAnchor),
            appTitleLabel.trailingAnchor.constraint(equalTo: darkView.trailingAnchor),

            appSubTitleLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: -20),
            appSubTitleLabel.leadingAnchor.constraint(equalTo: darkView.leadingAnchor),
            appSubTitleLabel.trailingAnchor.constraint(equalTo: darkView.trailingAnchor),
        ])

        UIView.animate(withDuration: 0.7, delay: 0.4, options: UIView.AnimationOptions.curveEaseIn) {
            self.backView.alpha = 1
        } completion: { _ in
            print("bitti")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.backLeadingAnchor.constant = 0
            self.backTopAnchor.constant = 0
            self.darkView.backgroundColor = .clear
            self.darkView.makeGradient(from: .clear, to: .black)

            for subView in self.darkView.subviews {
                subView.alpha = 1
            }

            UIView.animate(
                withDuration: 0.7,
                delay: 0.1,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.2,
                options: .curveEaseIn
            ) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                print("bitti")
            }
        }
    }
}

extension UIView {
    func makeGradient(from: UIColor, to: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [to.cgColor, from.cgColor, to.cgColor, to.cgColor]
        let point4 = 0.0
        let point1 = 0.3
        let point2 = 0.9
        let point3 = 1.0
        gradient.locations = [point4 as NSNumber, point1 as NSNumber, point2 as NSNumber, point3 as NSNumber]

        layer.insertSublayer(gradient, at: 0)
    }
}
