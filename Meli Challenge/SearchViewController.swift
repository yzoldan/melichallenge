//
//  ViewController.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 05-07-2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var apiManager = ApiManager()
    var loading = false {
        didSet {
            searchButton.isEnabled = !loading
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
    }
    
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
        // TODO: pass response to results vc
    }

    @IBAction func searchTapped(_ sender: UIButton) {
        Task {
            await searchItems()
        }
        searchTextField.resignFirstResponder()
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Task {
            await searchItems()
        }
        textField.resignFirstResponder()
        return true
    }
}

