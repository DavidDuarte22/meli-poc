//
//  ResultsTableView.swift
//  Meli-Poc
//
//  Created by David Duarte on 09/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit
import RxSwift

class ResultsTableView: UITableViewController {
    var results: [Product]
    var query: String
    
    var resultPresenter: ResultPresenterInterface
    let disposeBag = DisposeBag()
    
    let spinner = SpinnerViewController()
    
    init(results: [Product], query: String, presenter: ResultPresenterInterface) {
        self.resultPresenter = presenter
        self.results = results
        self.query = query
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        subscribeToObserver(self.resultPresenter.presenterToViewProductDetailSubject)
        self.tableView.register(UINib(nibName: "ResultCell", bundle: nil), forCellReuseIdentifier: "resultCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = query
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
    }
    
    // MARK: subscribeToObserver() :GetProductDetail
    func subscribeToObserver (_ subject: PublishSubject<ProductDetail>) {
        subject.subscribe(
            onNext: {(productDetail) in
                self.spinner.removeSpinner()
        },
            onError: {(error) in
                self.spinner.removeSpinner()
        }).disposed(by: disposeBag)
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultCell
        cell.titleLabel.text = results[indexPath.row].title
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if results[indexPath.row].shipping.free_shipping {
            cell.dispatchLabel.text = "Envío gratis!"
        } else {
            cell.dispatchLabel.isHidden = true
        }
        cell.productURLImage = results[indexPath.row].thumbnail
        
        let price = results[indexPath.row].price as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: Currency.ARS.rawValue)
        cell.priceLabel.text = formatter.string(from: price)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultPresenter.getProductDetail(productId: results[indexPath.row].id)
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
}
