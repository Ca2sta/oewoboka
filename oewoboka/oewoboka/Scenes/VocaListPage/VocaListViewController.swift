//
//  VocaListViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//
import Foundation
import UIKit
import SnapKit

final class VocaListViewController: UIViewController {
    
    let vocaListTableView = UITableView()
    let vocaSearchController = UISearchController(searchResultsController: nil)
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: VocaListViewController.self, action: #selector(addButtonTapped))

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        vocaSearchController.delegate = self
        vocaSearchController.searchBar.placeholder = "단어 검색"

        
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
    
    @objc func addButtonTapped() {
        print("test")
        
    }
    
}
extension VocaListViewController : UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! VocaListTableViewCell
        
        cell.vocaListLabel.text = "Voca List \((indexPath.row + 1))"
        cell.vocaNumbersLabel.text = "V: \(indexPath.row)"
        cell.completeNumbersLabel.text = "Com: \(indexPath.row)"
        cell.uncompleteNumbersLabel.text = "Ucm: \(indexPath.row)"
        cell.inProgressRateLabel.text = "Achievement Rate: \(indexPath.row)%"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func updateSearchResults(for searchController: UISearchController) {
        print("text")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vocaViewController = VocaViewController()
        
        self.navigationController?.pushViewController(vocaViewController, animated: true)
    }
}
    
