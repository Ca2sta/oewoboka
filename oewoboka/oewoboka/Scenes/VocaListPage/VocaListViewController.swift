//
//  VocaListViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//
import Foundation
import UIKit
import SnapKit
import CoreData

final class VocaListViewController: UIViewController, UISearchResultsUpdating {
    
    let vocaListTableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        return view
    }()
    let vocaSearchController = UISearchController(searchResultsController: nil)
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: VocaListViewController.self, action: #selector(addButtonTapped))

    var filteredVocaLists: [VocabularyEntity] = []
    
    let coreDataManager = VocabularyRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpSearchController()
        vocaListTableView.delegate = self
        vocaListTableView.dataSource = self
        vocaListTableView.register(VocaListTableViewCell.self, forCellReuseIdentifier: VocaListTableViewCell.identifier)

           self.vocaListTableView.rowHeight = UITableView.automaticDimension

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vocaListTableView.reloadData()
    }
    
    func setUpUI() {
        self.view.addSubview(vocaListTableView)
        navigationItem.titleView = vocaSearchController.searchBar
        navigationItem.rightBarButtonItem = addButton
        self.navigationController?.navigationBar.tintColor = .systemPink
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        
        vocaListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        vocaSearchController.searchBar.snp.makeConstraints { make in
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

        let addAction = UIAlertAction(title: "단어장 추가", style: .default) { [weak self] (_) in
            print("단어장 추가를 선택했습니다.")
            
            let vocabularyVC = VocabularyViewController()
            self?.navigationController?.pushViewController(vocabularyVC, animated: true)
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
        if vocaSearchController.isActive {
            return filteredVocaLists.count
        } else {
            return coreDataManager.allFetch().count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VocaListTableViewCell.identifier, for: indexPath) as! VocaListTableViewCell
        
        var targetAry: [VocabularyEntity] = []
        if vocaSearchController.isActive {
            targetAry = filteredVocaLists
        } else {
            targetAry = coreDataManager.allFetch()
        }
        cell.bind(data: targetAry[indexPath.row])
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            filteredVocaLists = coreDataManager.allFetch()
        } else {
            let filterAry = coreDataManager.allFetch().filter{$0.title.contains(searchText)}
            filteredVocaLists = filterAry
        }
        vocaListTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var targetAry: [VocabularyEntity] = []
        if vocaSearchController.isActive {
            targetAry = filteredVocaLists
        } else {
            targetAry = coreDataManager.allFetch()
        }
        
        let vocaViewController = VocaViewController(vocabularyID: targetAry[indexPath.row].objectID)
        vocaListTableView.reloadData()
        self.navigationController?.pushViewController(vocaViewController, animated: true)
    }
}
    
