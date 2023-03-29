//
//  ZKImageViewerAnimator.swift
//  ZKImageViewerAnimator
//
//  Created by pzk on 2023/3/29.
//

import Foundation
import UIKit

class ZKImageViewerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var transitionImageView: UIImageView?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let transitionImageView = transitionImageView else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        containerView.backgroundColor = .clear

        if toVC.isBeingPresented {
            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0

            let transitionImageViewFrame = transitionImageView.convert(transitionImageView.bounds, to: containerView)
            let imageViewCopy = UIImageView(frame: transitionImageViewFrame)
            imageViewCopy.image = transitionImageView.image
            imageViewCopy.contentMode = .scaleAspectFit
            imageViewCopy.clipsToBounds = true
            containerView.addSubview(imageViewCopy)

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toVC.view.alpha = 1
                imageViewCopy.frame = toVC.view.bounds
            }, completion: { finished in
                imageViewCopy.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }

        if fromVC.isBeingDismissed {
            containerView.addSubview(fromVC.view)
            fromVC.view.alpha = 1

            let transitionImageViewFrame = transitionImageView.convert(transitionImageView.bounds, to: containerView)
            let imageViewCopy = UIImageView(frame: fromVC.view.bounds)
            imageViewCopy.image = transitionImageView.image
            imageViewCopy.contentMode = .scaleAspectFit
            imageViewCopy.clipsToBounds = true
            containerView.addSubview(imageViewCopy)

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromVC.view.alpha = 0
                imageViewCopy.frame = transitionImageViewFrame
            }, completion: { finished in
                imageViewCopy.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }
    }
}

