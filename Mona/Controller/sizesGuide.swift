//
//  sizesGuide.swift
//  Mona
//
//  Created by Tariq on 9/15/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class sizesGuide: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var sizesImage: UIImageView!
    
    var imageGuide = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scroll.delegate = self
        addTitleImage()
        
        imageGuideRefresh()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(gestureRecognizer:)))
        tapRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func imageGuideRefresh(){
        let urlWithoutEncoding = ("\(URLs.file_root)\(self.imageGuide)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        sizesImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            sizesImage.kf.setImage(with: url)
        }
    }
    
    func addTitleImage(){
        let navController = navigationController!
        
        let image = UIImage(named: "Mona")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = (bannerWidth / 2 - (image?.size.width)! / 2)
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return sizesImage
    }

    @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        let scale = min(scroll.maximumZoomScale, scroll.maximumZoomScale)
        
        if scale != scroll.zoomScale {
            let point = gestureRecognizer.location(in: sizesImage)
            
            let scrollSize = scroll.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scroll.zoom(to:CGRect(origin: origin, size: size), animated: true)
            print(CGRect(origin: origin, size: size))
        }else if scale == scroll.maximumZoomScale{
            scroll.zoom(to:CGRect(origin: scroll.frame.origin, size: scroll.frame.size), animated: true)
        }
    }

}
