//
//  SearchResultsViewController.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 08-07-2022.
//

import UIKit
import SwiftUI

class SearchResultsViewController: UIViewController {
    
    // MARK: - Properties
    var searchResponse: SearchResponse
    private var items = [Item]()
    private var loading = false
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    init(response: SearchResponse) {
        self.searchResponse = response
        self.items = searchResponse.results
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Búsqueda: \(searchResponse.query)"
        view.backgroundColor = .white
        addSubViews()
        refresh()
    }
    
    private func addSubViews() {
        view.addSubview(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in
            self.refresh()
        }
    }
    
    
    // MARK: - Methods

    private func refresh() {
        collectionView.reloadData()
    }
    
    private func loadNextPage() async {
        guard !loading else { return }
        guard searchResponse.paging.total > items.count else { return }
        loading = true
        let result = await ApiManager().searchItems(forQuery: searchResponse.query, limit: searchResponse.paging.limit, offset: items.count)
        switch result {
        case .failure(let error):
            let alertVC = UIAlertController(title: "Error", message: error.customMessage, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertVC, animated: true)
        case .success(let newResponse):
            searchResponse = newResponse
            items.append(contentsOf: searchResponse.results)
            collectionView.reloadData()
        }
        loading = false
    }
}

// MARK: - UICollectionView
extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculates number of columns based on screen width and ideal item width. It ensures a minimum of two columns
        let columns = max(2, Int(collectionView.width / ItemCollectionViewCell.idealWidth))
        let size = CGSize(width: collectionView.width / CGFloat(columns), height: ItemCollectionViewCell.idealHeight)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // We load pictures of the item before passing it to the detail view
        Task {
            let item = items[indexPath.item]
            let result = await ApiManager().getItemPictures(withId: item.id)
            switch result {
            case .failure(let error):
                let alertVC = UIAlertController(title: "Error", message: error.customMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default))
                present(alertVC, animated: true)
            case .success(let pictures):
                let hostVC = UIHostingController(rootView: ItemView(item: item, pictures: pictures))
                navigationController?.pushViewController(hostVC, animated: true)
            }
        }
    }
    
    // Infinite scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.reachedBottom {
            Task {
                await loadNextPage()
            }
        }
    }
}

