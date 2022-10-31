// IntroViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// IntroViewController контроллер онбоардинга
final class IntroViewController: UIViewController {
    // MARK: - Visual Components

    private let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: Constants.introBack)
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()

    private let moveNextButton: UIButton = {
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

    private let darkView: UIView = {
        let view = UIView()
        view.makeGradient(from: .black, to: .clear)
        return view
    }()

    private let onboardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.chilliMedium, size: 24)
        label.textColor = .white
        label.text = Constants.firstBoardText
        return label
    }()

    private let onboardSubLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.chilliRegular, size: 16)
        label.textColor = .white
        label.text = Constants.firstBoardSubText
        label.numberOfLines = 2
        return label
    }()

    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.chilliBold, size: 42)
        label.textColor = UIColor(named: Constants.ownYellowColor)
        label.text = Constants.appTitle
        label.textAlignment = .center
        return label
    }()

    private let appSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.chilliBold, size: 30)
        label.textColor = .white
        label.text = Constants.appSubTitle
        label.textAlignment = .center
        return label
    }()

    // MARK: - Public Properties

    private var currentPage = 0
    private var backImViewTopAnchor = NSLayoutConstraint()
    private var backImViewLeadAnchor = NSLayoutConstraint()
    private var darkViewHeight = NSLayoutConstraint()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAlphaToViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layoutSetup()
    }

    // MARK: - Public methods

    @objc func moveNextAction() {
        if currentPage <= 1 {
            backImViewLeadAnchor.constant -= view.frame.width
            backImViewTopAnchor.constant -= (view.frame.width)
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

    private func setAlphaToViews() {
        for subView in darkView.subviews {
            subView.alpha = 0
        }
    }

    private func setupView() {
        view.backgroundColor = UIColor(named: Constants.ownDarkerColor)
        view.addSubview(backImageView)
        view.addSubview(darkView)
        darkView.addSubview(moveNextButton)
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

        moveNextButton.addTarget(self, action: #selector(moveNextAction), for: .touchUpInside)
    }

    private func moveBackAction() {
        if currentPage >= 1 {
            backImViewLeadAnchor.constant += view.frame.width
            backImViewTopAnchor.constant += (view.frame.width)

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
        moveNextButton.translatesAutoresizingMaskIntoConstraints = false
        backImageViewConstraints()
        moveNextButtonConstraints()
        darkViewConstraints()
        onboardLabelConstraints()
        onboardSubLabelConstraints()
        appTitleLabelConstraints()
        appSubTitleLabelConstraints()
        animateAlpha()
        animateAlphaToVisible()
    }

    private func moveNextButtonConstraints() {
        NSLayoutConstraint.activate([
            moveNextButton.trailingAnchor.constraint(equalTo: darkView.trailingAnchor, constant: -30),
            moveNextButton.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: -50),
            moveNextButton.widthAnchor.constraint(equalToConstant: 100),
            moveNextButton.heightAnchor.constraint(equalToConstant: 34),
        ])
    }

    private func darkViewConstraints() {
        NSLayoutConstraint.activate([
            darkView.topAnchor.constraint(equalTo: view.topAnchor),
            darkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            darkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            darkView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func onboardLabelConstraints() {
        NSLayoutConstraint.activate([
            onboardLabel.leadingAnchor.constraint(equalTo: darkView.leadingAnchor, constant: 16),
            onboardLabel.trailingAnchor.constraint(equalTo: darkView.trailingAnchor, constant: -16),
            onboardLabel.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: -140),
        ])
    }

    private func onboardSubLabelConstraints() {
        NSLayoutConstraint.activate([
            onboardSubLabel.topAnchor.constraint(equalTo: onboardLabel.bottomAnchor, constant: 4),
            onboardSubLabel.leadingAnchor.constraint(equalTo: darkView.leadingAnchor, constant: 16),
            onboardSubLabel.trailingAnchor.constraint(equalTo: darkView.trailingAnchor, constant: -16),
        ])
    }

    private func appTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            appTitleLabel.topAnchor.constraint(equalTo: darkView.topAnchor, constant: 60),
            appTitleLabel.leadingAnchor.constraint(equalTo: darkView.leadingAnchor),
            appTitleLabel.trailingAnchor.constraint(equalTo: darkView.trailingAnchor),
        ])
    }

    private func appSubTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            appSubTitleLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: -20),
            appSubTitleLabel.leadingAnchor.constraint(equalTo: darkView.leadingAnchor),
            appSubTitleLabel.trailingAnchor.constraint(equalTo: darkView.trailingAnchor),
        ])
    }

    private func backImageViewConstraints() {
        let backWidth = view.frame.width * 3
        let backHeight = view.frame.height + (view.frame.width * 2)
        let viewWidth = view.frame.width
        backImViewTopAnchor = backImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: viewWidth)
        backImViewLeadAnchor = backImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewWidth)
        darkViewHeight = darkView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -(view.frame.height))

        NSLayoutConstraint.activate([
            backImViewTopAnchor,
            backImViewLeadAnchor,
            backImageView.widthAnchor.constraint(equalToConstant: backWidth),
            backImageView.heightAnchor.constraint(equalToConstant: backHeight),
        ])
    }

    private func animateAlphaToVisible() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.backImViewLeadAnchor.constant = 0
            self.backImViewTopAnchor.constant = 0
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

    private func animateAlpha() {
        UIView.animate(withDuration: 0.7, delay: 0.4, options: UIView.AnimationOptions.curveEaseIn) {
            self.backImageView.alpha = 1
        } completion: { _ in
            print("bitti")
        }
    }
}
