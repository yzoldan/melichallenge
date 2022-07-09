//
//  SearchResultsViewController.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 08-07-2022.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    // MARK: - Properties
    var searchResponse: SearchResponse
    private var items: [Item] {
        return searchResponse.results
    }
    
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
}

// MARK: - UICollectionView
extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns = max(2, Int(collectionView.width / ItemCollectionViewCell.idealWidth))
        let size = CGSize(width: collectionView.width / CGFloat(columns), height: ItemCollectionViewCell.idealHeight)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

