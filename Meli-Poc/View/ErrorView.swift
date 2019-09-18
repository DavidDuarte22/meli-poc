//
//  ErrorView.swift
//  Meli-Poc
//
//  Created by David Duarte on 16/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate {
    func reloadView()
}

class ErrorView: UIViewController {
    var error: ErrorStruct
    var delegate: ErrorViewDelegate?
    
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var titleError: UILabel!
    @IBOutlet weak var messageError: UILabel!
    
    
    required init(error: ErrorStruct) {
        self.error = error
        super.init(nibName: "ErrorView", bundle: nil)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(hexString: "#E9E9E9")
        titleError.text = error.title
        messageError.text = error.message
        
        guard let errorType = self.error.type else {
            errorImage.image = UIImage(named: "")
            return
        }
        
        switch errorType {
        case MeliError.networkError:
            errorImage.image = UIImage(named: "connection_error")
        default:
            errorImage.image = UIImage(named: "")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func closeButton(_ sender: Any) {
        delegate?.reloadView()
        self.dismiss(animated: true, completion: nil)
    }
}
