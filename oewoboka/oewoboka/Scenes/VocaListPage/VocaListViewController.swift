//
//  VocaListViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//
import Foundation
import UIKit
import SnapKit

struct VocaList {
    let name: String
    let description: String
}

final class VocaListViewController: UIViewController, UISearchResultsUpdating {
    
    let vocaListTableView = UITableView()
    let vocaSearchController = UISearchController(searchResultsController: nil)
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: VocaListViewController.self, action: #selector(addButtonTapped))
    var allVocaLists = [
        VocaList(name: "Voca List 1", description: "This is the first Voca List"),
        VocaList(name: "Voca List 2", description: "Another Voca List"),
    ]
    var filteredVocaLists = [VocaList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpSearchController()
        vocaListTableView.delegate = self
        vocaListTableView.dataSource = self
        vocaListTableView.register(VocaListTableViewCell.self, forCellReuseIdentifier: "ListCell")
        
    }

    
    func setUpUI() {
        self.view.addSubview(vocaListTableView)
        navigationItem.titleView = vocaSearchController.searchBar
        navigationItem.rightBarButtonItem = addButton
        
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        
        vocaListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        vocaSearchController.searchBar.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-80)
            make.top.equalTo(additionalSafeAreaInsets)
        }
    }
    
    func setUpSearchController() {
        vocaSearchController.delegate = self
        vocaSearchController.searchBar.placeholder = "단어장 검색"
        vocaSearchController.hidesNavigationBarDuringPresentation = false
        vocaSearchController.searchResultsUpdater = self

   
        definesPresentationContext = true
    }


    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let addAction = UIAlertAction(title: "단어장 추가", style: .default) { _ in
            print("단어장 추가를 선택했습니다.")
        }

        let sortAction = UIAlertAction(title: "정렬 순서", style: .default) { _ in
            print("정렬 순서를 선택했습니다.")
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(addAction)
        alertController.addAction(sortAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}
extension VocaListViewController : UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! VocaListTableViewCell
        
        let vocaList: VocaList
        if vocaSearchController.isActive {
            if indexPath.row < filteredVocaLists.count {
                vocaList = filteredVocaLists[indexPath.row]
            } else {
                vocaList = VocaList(name: "", description: "")
            }
        } else {
            if indexPath.row < allVocaLists.count {
                vocaList = allVocaLists[indexPath.row]
            } else {
                vocaList = VocaList(name: "", description: "")
            }
        }
        
        cell.vocaListLabel.text = vocaList.name
        //워드모델이 필요할듯?
        cell.vocaNumbersLabel.text = "V: \(indexPath.row)"
        cell.completeNumbersLabel.text = "✅: \(indexPath.row)"
        cell.uncompleteNumbersLabel.text = "❎: \(indexPath.row)"
        cell.inProgressRateLabel.text = "\(indexPath.row)%"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            filteredVocaLists = allVocaLists
        } else {
            filteredVocaLists = allVocaLists.filter { vocaList in
                return vocaList.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        vocaListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vocaViewController = VocaViewController()
        
        self.navigationController?.pushViewController(vocaViewController, animated: true)
    }
}
    
