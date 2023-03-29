//
//  ZKImageViewerView.swift
//  ZKImageViewerAnimator
//
//  Created by pzk on 2023/3/29.
//

import Foundation
import UIKit

class ZKImageViewerView: UIView {
    var tapPressClosure: (() -> Void)?
    var longPressClosure: (() -> Void)?

    private lazy var scrollView: UIScrollView = {
        let tmp = UIScrollView(frame: UIScreen.main.bounds)
        tmp.backgroundColor = .clear
        tmp.delegate = self
        tmp.minimumZoomScale = 0.5
        tmp.maximumZoomScale = 3.0
        tmp.zoomScale = 1.0
        tmp.bouncesZoom = false
        tmp.clipsToBounds = false
        tmp.showsVerticalScrollIndicator = false
        tmp.showsHorizontalScrollIndicator = false
        tmp.contentSize = UIScreen.main.bounds.size
        return tmp
    }()

    private(set) lazy var imageView: UIImageView = {
        let tmp = UIImageView(frame: UIScreen.main.bounds)
        tmp.backgroundColor = .clear
        tmp.contentMode = .scaleAspectFit
        tmp.clipsToBounds = true
        return tmp
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addGestures()
    }

    required init?(coder: NSCoder) {
        fatalError(#function + "shouldn't be called!")
    }

    private func setupView() {
        backgroundColor = .black
        clipsToBounds = true
        addSubview(scrollView)
        scrollView.addSubview(imageView)
    }

    private func addGestures() {
        self.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.addGestureRecognizer(tap)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        scrollView.addGestureRecognizer(pinch)

        let long = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        self.addGestureRecognizer(long)
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        tapPressClosure?()
    }

    @objc private func handleDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        scrollView.setZoomScale(1.0, animated: true)
    }

    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let scale = gesture.scale
            scrollView.zoomScale = scrollView.zoomScale * scale
            gesture.scale = 1.0
        }
    }

    @objc private func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        longPressClosure?()
    }
}

extension ZKImageViewerView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
}
