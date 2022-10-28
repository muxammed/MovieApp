// TransitionManager.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// TransitionManager класс для кастомного переходов увеличения с ячейки collectionview в imageview который в следующем контроллере
final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - Initializers

    init(duration: TimeInterval) {
        self.duration = duration
    }

    // MARK: - Public methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }

        animateTransition(from: fromViewController, to: toViewController, with: transitionContext)
    }

    // MARK: - Private Methods

    private let duration: TimeInterval
    private var operation = UINavigationController.Operation.push
}

// MARK: - UINavigationControllerDelegate

extension TransitionManager: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        self.operation = operation

        if operation == .push {
            return self
        }

        return nil
    }
}

// MARK: - Animations

private extension TransitionManager {
    func animateTransition(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        with context: UIViewControllerContextTransitioning
    ) {
        switch operation {
        case .push:
            guard
                let albumsViewController = fromViewController as? SearchViewController,
                let detailsViewController = toViewController as? DetailsViewController
            else { return }

            presentViewController(detailsViewController, from: albumsViewController, with: context)

        case .pop:
            guard
                let detailsViewController = fromViewController as? DetailsViewController,
                let albumsViewController = toViewController as? SearchViewController
            else { return }

            dismissViewController(detailsViewController, to: albumsViewController)

        default:
            break
        }
    }

    func presentViewController(
        _ toViewController: DetailsViewController,
        from fromViewController: SearchViewController,
        with context: UIViewControllerContextTransitioning
    ) {
        guard
            let movieCell = fromViewController.currentCell,
            let movieCoverImageView = fromViewController.currentCell?.moviePhoto

        else { return }
        toViewController.navigationController?.navigationBar.isHidden = true

        let detailsImageView = toViewController.headerView.movieCover
        toViewController.view.layoutIfNeeded()

        let containerView = context.containerView

        let snapshotContentView = UIView()
        snapshotContentView.backgroundColor = .black
        snapshotContentView.frame = containerView.convert(movieCell.contentView.frame, from: movieCell)
        snapshotContentView.layer.cornerRadius = movieCell.contentView.layer.cornerRadius

        let snapshotMovieCoverImageView = UIImageView()
        snapshotMovieCoverImageView.clipsToBounds = true
        snapshotMovieCoverImageView.contentMode = movieCoverImageView.contentMode
        snapshotMovieCoverImageView.image = movieCoverImageView.image
        snapshotMovieCoverImageView.layer.cornerRadius = movieCoverImageView.layer.cornerRadius
        snapshotMovieCoverImageView.frame = containerView.convert(movieCoverImageView.frame, from: movieCell)

        let gradient = CAGradientLayer()
        gradient.frame = snapshotMovieCoverImageView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
        let point4 = 0.3
        let point2 = 0.75
        let point3 = 1.0
        gradient.locations = [point4 as NSNumber, point2 as NSNumber, point3 as NSNumber]
        snapshotMovieCoverImageView.layer.insertSublayer(gradient, at: 0)

        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshotContentView)
        containerView.addSubview(snapshotMovieCoverImageView)

        toViewController.view.alpha = 0

        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.7) {
            snapshotContentView.frame = containerView.convert(toViewController.view.frame, from: toViewController.view)

            snapshotMovieCoverImageView.frame = containerView.convert(
                detailsImageView.frame,
                from: detailsImageView
            )

            let frm = CGRect(
                x: detailsImageView.frame.minX,
                y: detailsImageView.frame.minY + 100,
                width: detailsImageView.frame.width + 20,
                height: detailsImageView.frame.height
            )
            gradient.frame = containerView.convert(frm, from: detailsImageView)
            snapshotMovieCoverImageView.layer.cornerRadius = 0
        }

        animator.addCompletion { position in
            toViewController.headerView.animator2.fractionComplete = 0
            snapshotMovieCoverImageView.removeFromSuperview()
            snapshotContentView.removeFromSuperview()
            context.completeTransition(position == .end)
            toViewController.navigationController?.navigationBar.isHidden = false
            toViewController.view.alpha = 1
        }
        animator.startAnimation()
    }

    func dismissViewController(
        _ fromViewController: DetailsViewController,
        to toViewController: SearchViewController
    ) {}
}
