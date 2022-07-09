//
//  ViewController.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 05-07-2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Properties
    
    var apiManager = ApiManager()
    var loading = false {
        didSet {
            searchButton.isEnabled = !loading
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar background color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .yellowBrandColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        searchTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Methods
    
    private func searchItems() async {
        guard !loading else { return }
        guard let query = searchTextField.text else { return }
//        guard !query.isEmpty else { return }
        
        loading = true
        let result = await apiManager.searchItems(forQuery: query)
        
        switch result {
        case .failure(let error):
            handleError(error)
        case .success(let response):
            handleSuccess(response)
        }
        loading = false
    }
    
    private func handleError(_ error: RequestError) {
        let alert = UIAlertController(title: "Error", message: error.customMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.searchTextField.becomeFirstResponder()
        })
        present(alert, animated: true)
    }
    
    private func handleSuccess(_ response: SearchResponse) {
        let resultsVC = SearchResultsViewController(response: response)
        navigationController?.pushViewController(resultsVC, animated: true)
    }

    @IBAction func searchTapped(_ sender: UIButton) {
        Task {
            await searchItems()
        }
        searchTextField.resignFirstResponder()
    }
    
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Task {
            await searchItems()
        }
        textField.resignFirstResponder()
        return true
    }
}

