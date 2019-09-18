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
    // instances of presenter
    var homePresenter = HomePresenter()
    // disposeBag for RxSwift
    let disposeBag = DisposeBag()
    // const and instances for searching flow
    let searchBar: UISearchBar = UISearchBar()
    var searchedProducts: [ProductSearched] = []
    var haveSearched: Bool = false
    var errorHappened = false
    
    
    let spinner = SpinnerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "SearchedProductsView", bundle: nil), forCellReuseIdentifier: "searchedProductCell")
        self.tableView.register(UINib(nibName: "SearchedHeaderView", bundle: nil), forCellReuseIdentifier: "searchedHeaderCell")
        
        
        // observer para productos buscados: Historial
        subscribeToObserver(self.homePresenter.presenterToViewSearchedProductSubject)
        
        customizeSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if errorHappened {
            reloadInputViews()
            
        }
        // cuando se vuelve a esta vista recargar historial
        homePresenter.retrieveRecentSearches()
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
        self.tableView.separatorStyle = .none
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "searchedProductCell") as! SearchedProductsView
        cell.titleLabel.text = searchedProducts[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.searchedProducts.count > 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
            headerView.backgroundColor =  UIColor(hexString: "#E9E9E9")
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
            return 40
        }
        return 0
    }
    
    // make search of product selected, searched before
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchedText = searchedProducts[indexPath.row].title else { return }
        // observer para productos
        subscribeToObserver(self.homePresenter.presenterToViewProductFromApiSubject)
        self.homePresenter.searchProduct(product: searchedText)
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
}
// MARK: Rx Observers
extension HomeView {
    // subscribeToObserver() :HistoricalSearches
    // onNext: show previous searches
    // onError: navigate to error view
    func subscribeToObserver (_ subject: PublishSubject<[ProductSearched]>) {
        subject.subscribe(
            onNext: {(arraySearchedProducts) in
                self.spinner.removeSpinner()
                self.searchedProducts = arraySearchedProducts
                self.tableView.reloadData()
        },
            onError: {(error) in
                self.spinner.removeSpinner()
        }).disposed(by: disposeBag)
    }
    
    // subscribeToObserver() :SearchResult
    // onNext: show results of current search
    // onError: navigate to error view
    func subscribeToObserver (_ subject: PublishSubject<ProductResult>) {
        subject.materialize()
        .subscribe(
            onNext: {(result) in
                self.spinner.removeSpinner()
        },
            onError: {(error) in
                self.spinner.removeSpinner()
        },
            onCompleted: {() in
                print("complete")
        }).disposed(by: disposeBag)
    }
}

// MARK: SearchBar()
extension HomeView: UISearchBarDelegate {
    // se agrega la barra de busqueda
    func customizeSearchBar () {
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Buscar..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        
        searchBar.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationController?.navigationBar.barTintColor = .init(UIColor(hexString: "#fddc00"))
    }
    // actions for clicking "search" button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            self.haveSearched = true
            // observer para productos
            subscribeToObserver(self.homePresenter.presenterToViewProductFromApiSubject)
            searchBar.resignFirstResponder()
            self.homePresenter.searchProduct(product: searchBarText)
            addChild(spinner)
            spinner.view.frame = view.frame
            view.addSubview(spinner.view)
            spinner.didMove(toParent: self)
        }
    }
}

