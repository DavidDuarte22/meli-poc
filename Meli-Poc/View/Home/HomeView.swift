//
//  HomeView.swift
//  Meli-Poc
//
//  Created by David Duarte on 04/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit
import RxSwift

class HomeView: UITableViewController {
    
    var homePresenter = HomePresenter()
    
    let disposeBag = DisposeBag()
    
    let searchBar:UISearchBar = UISearchBar()
    var searchedProducts: [ProductSearched] = []
    var haveSearched: Bool = false
    
    let spinner = SpinnerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "SearchedProductsView", bundle: nil), forCellReuseIdentifier: "searchedProductCell")
        self.tableView.register(UINib(nibName: "SearchedHeaderView", bundle: nil), forCellReuseIdentifier: "searchedHeaderCell")
        // observer para productos
        subscribeToObserver(self.homePresenter.presenterProductSubject)
        // observer para productos buscados: Historial
        subscribeToObserver(self.homePresenter.presenterSearchedProductArraySubject)
        customizeSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // cuando se vuelve a esta vista recargar historial
        homePresenter.retrieveRecentSearches()
    }
    
    // se agrega la barra de busqueda
    // MARK: SearchBar()
    func customizeSearchBar () {
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Buscar..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()

        searchBar.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationController?.navigationBar.barTintColor = .init(red: 0.99, green: 0.94, blue: 0.35, alpha: 1.0)
        
    }
    
    // MARK: subscribeToObserver() :HistoricalSearches
    func subscribeToObserver (_ subject: PublishSubject<[ProductSearched]>) {
        subject.subscribe(
            onNext: {(arraySearchedProducts) in
                self.searchedProducts = arraySearchedProducts
                self.tableView.reloadData()
        },
            onError: {(error) in
                print(error)
        }).disposed(by: disposeBag)
    }
    
    // MARK: subscribeToObserver() :SearchResult
    func subscribeToObserver (_ subject: PublishSubject<ProductResult>) {
        subject.subscribe(
            onNext: {(results) in
                if let navigationController = self.navigationController {
                    self.spinner.willMove(toParent: nil)
                    self.spinner.view.removeFromSuperview()
                    self.spinner.removeFromParent()
                    self.homePresenter.showSearchedResults(products: results.results, title: results.query, navigationController: navigationController)
                }
        },
            onError: {(error) in
                print(error)
        }).disposed(by: disposeBag)
    }
    
    // MARK: TableView Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchedProducts.count == 0 {
            if !haveSearched {
                tableView.setEmptyView(title: "Please, make a search :D", message: "")
            } else {
                tableView.setEmptyView(title: "We couldn't find this :(", message: "Please, make another search")
            }
        }
        return searchedProducts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "searchedProductCell") as! SearchedProductsView
        cell.titleLabel.text = searchedProducts[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.searchedProducts.count > 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let label = UILabel()
            label.frame = CGRect.init(x: 10, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.font = label.font.withSize(14)
            label.text = "BUSQUEDAS RECIENTES"
            label.textColor = .lightGray
            headerView.addSubview(label)
            
            return headerView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.searchedProducts.count > 0 {
            return 50
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchedText = searchedProducts[indexPath.row].title else { return }
        self.homePresenter.searchProduct(product: searchedText)
    }
    
}


extension HomeView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            self.haveSearched = true
            searchBar.resignFirstResponder()
            self.homePresenter.searchProduct(product: searchBarText)
            addChild(spinner)
            spinner.view.frame = view.frame
            view.addSubview(spinner.view)
            spinner.didMove(toParent: self)
        }
    }
}

