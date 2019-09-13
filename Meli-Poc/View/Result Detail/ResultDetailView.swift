//
//  ResultDetailView.swift
//  Meli-Poc
//
//  Created by David Duarte on 09/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit

class ResultDetailView: UIViewController {
    let product: ProductDetail
    var imageArray: [UIImage] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var productCondition: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productShipping: UILabel!
    @IBOutlet weak var sellerUbication: UILabel!
    
    required init(product: ProductDetail) {
        self.product = product
        super.init(nibName: "ResultDetailView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        fillingCarousel()
        fillingView()
        scrollView.delegate = self
        pageControl.numberOfPages = product.pictures.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .darkGray
        view.bringSubviewToFront(pageControl)
    }
    
    func setupSlideScrollView(slides : [UIImage]) {
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: scrollView.contentSize.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            let imageview = UIImageView()
            imageview.image = slides[i]
            
            let xPosition = self.scrollView.frame.width * CGFloat(i)
            imageview.frame = CGRect(x: xPosition, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            imageview.contentMode = .scaleAspectFit
            scrollView.addSubview(imageview)

        }
    }
    
    func fillingCarousel () {
        
        for image in product.pictures {
            let queue = OperationQueue()
            queue.addOperation {() -> Void in
                do {
                    /* block for fetch photo */
                    let url = URL(string: image.secure_url)!
                    let data = try Data(contentsOf: url)
                    let img = UIImage(data: data)
                    /* */
                    
                    // display in cell when has it image
                    OperationQueue.main.addOperation({ () -> Void in
                       
                        self.imageArray.append(img!)
                        self.setupSlideScrollView(slides: self.imageArray)
                        
                        //self.scrollImageView.image = img
                    })
                } catch {
                    return
                }
            }
        }

    }
        
    func fillingView () {
        self.productTitle.text = product.title
        
        switch product.condition {
        case "used":
            self.productCondition.text = "USADO"
        case "new":
            self.productCondition.text = "NUEVO"
        default:
            self.productCondition.isHidden = true
        }
        
        self.sellerUbication.text = "\(product.seller_address.country.name) - \(product.seller_address.state.name)"
        let price = product.price as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: Currency.ARS.rawValue)
        self.productPrice.text = formatter.string(from: price)
        
        if product.shipping.free_shipping {
            self.productShipping.text = "Envío gratis!"
        } else {
            self.productShipping.isHidden = true
        }
    }
    
}


extension ResultDetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
