//
//  ResultCell.swift
//  Meli-Poc
//
//  Created by David Duarte on 09/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    override func awakeFromNib() {
        
    }
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dispatchLabel: UILabel!
    
    var productURLImage: String?
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        if let productURLImage = productURLImage {
            // while we get the image set a provisional image
            self.productImageView.image = UIImage(named: "empty_image")
            let queue = OperationQueue()
            queue.addOperation {() -> Void in
                do {
                    /* block for fetch photo */
                    let url = URL(string: productURLImage)!
                    let data = try Data(contentsOf: url)
                    let img = UIImage(data: data)
                    /* */
                    
                    // display in cell when has it image
                    OperationQueue.main.addOperation({ () -> Void in
                        
                        self.productImageView.image = img
                    })
                } catch {
                    return
                }
            }
        }
    }
}
