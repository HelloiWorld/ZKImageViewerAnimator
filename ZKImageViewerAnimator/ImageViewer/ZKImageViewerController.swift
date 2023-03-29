//
//  ZKImageViewerController.swift
//  ZKImageViewerAnimator
//
//  Created by pzk on 2023/3/29.
//

import Foundation
import UIKit

class ZKImageViewerController: UIViewController {

    private lazy var previewView: ZKImageViewerView = {
        let tmp = ZKImageViewerView(frame: self.view.bounds)
        tmp.tapPressClosure = { [weak self] in
            self?.dismiss()
        }
        tmp.longPressClosure = { [weak self] in
            self?.handleLongGesture()
        }
        return tmp
    }()

    class func show(with image: UIImage?, in vc: UIViewController & UIViewControllerTransitioningDelegate) {
        let targetVC = ZKImageViewerController()
        targetVC.modalPresentationStyle = .custom
        targetVC.transitioningDelegate = vc
        vc.present(targetVC, animated: true) {
            targetVC.previewView.imageView.image = image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(previewView)
    }

    private func dismiss() {
        previewView.imageView.image = nil
        self.dismiss(animated: true)
    }
    
    private func handleLongGesture() {
        // do something
    }
}
