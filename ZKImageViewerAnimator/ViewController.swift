//
//  ViewController.swift
//  ZKImageViewerAnimator
//
//  Created by pzk on 2023/3/29.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var animator = ZKImageViewerAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for i in 1...5 {
            let imgV = UIImageView()
            imgV.frame = CGRect(x: 20, y: 50 + 100 * i, width: 80, height: 80)
            let color = UIColor(named: "Color\(i)")
            imgV.image = color?.imageWithColor(CGSize(width: 80, height: 80))
            imgV.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
            imgV.addGestureRecognizer(tap)
            self.view.addSubview(imgV)
        }
    }
    
    @objc private func tapImage(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view as? UIImageView else { return }
        animator.transitionImageView = view
        ZKImageViewerController.show(with: view.image, in: self)
    }

}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard presented is ZKImageViewerController else { return nil }
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard dismissed is ZKImageViewerController else { return nil }
        return animator
    }
}

extension UIColor {
    
    // 生成纯色图片
    func imageWithColor(_ size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { (context) in
            self.setFill()
            let path = UIBezierPath(rect: CGRect(origin: .zero, size: size))
            path.fill()
        }
        return image
    }
    
}

