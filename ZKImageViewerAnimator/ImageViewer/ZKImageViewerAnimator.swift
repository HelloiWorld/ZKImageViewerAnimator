//
//  ZKImageViewerAnimator.swift
//  ZKImageViewerAnimator
//
//  Created by pzk on 2023/3/29.
//

import Foundation
import UIKit

public protocol ZKImageViewerTransitionProtocol where Self: UIViewController {
    var animator: ZKImageViewerAnimator { get }
}

public class ZKImageViewerAnimator: NSObject {
    var transitionImageView: UIImageView?
}

extension ZKImageViewerAnimator: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard presented is ZKImageViewerController else { return nil }
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard dismissed is ZKImageViewerController else { return nil }
        return self
    }
}

extension ZKImageViewerAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        containerView.backgroundColor = .clear

        if toVC.isBeingPresented {
            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0

            var transImageView: UIImageView?
            if let transitionImageView = self.transitionImageView {
                let transitionImageViewFrame = transitionImageView.convert(transitionImageView.bounds, to: containerView)
                let imageViewCopy = UIImageView(frame: transitionImageViewFrame)
                imageViewCopy.image = transitionImageView.image
                imageViewCopy.contentMode = .scaleAspectFit
                imageViewCopy.clipsToBounds = true
                containerView.addSubview(imageViewCopy)
                transImageView = imageViewCopy
            }

            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                toVC.view.alpha = 1
                transImageView?.frame = toVC.view.bounds
            }, completion: { finished in
                transImageView?.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }

        if fromVC.isBeingDismissed {
            containerView.addSubview(fromVC.view)
            fromVC.view.alpha = 1

            var transImageView: UIImageView?
            var transImageViewFrame: CGRect = .zero
            if let transitionImageView = self.transitionImageView {
                let transitionImageViewFrame = transitionImageView.convert(transitionImageView.bounds, to: containerView)
                let imageViewCopy = UIImageView(frame: fromVC.view.bounds)
                imageViewCopy.image = transitionImageView.image
                imageViewCopy.contentMode = .scaleAspectFit
                imageViewCopy.clipsToBounds = true
                containerView.addSubview(imageViewCopy)
                transImageView = imageViewCopy
                transImageViewFrame = transitionImageViewFrame
            }

            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                fromVC.view.alpha = 0
                transImageView?.frame = transImageViewFrame
            }, completion: { finished in
                transImageView?.removeFromSuperview()
                transitionContext.completeTransition(finished)
                self.transitionImageView = nil
            })
        }
    }
}

