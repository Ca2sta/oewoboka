//
//  VocaViewController.swift
//  oewoboka
//
//  Created by Lee on 2023/09/26.
//

import UIKit
import SnapKit
import CoreData

class VocaViewController: UIViewController {
    let vocaTableView = UITableView()
    let vocaSearchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "단어 검색"
        return searchBar
    }()
    let allLabel : UILabel = {
        let label = UILabel()
        label.text = "전체 단어수: 0"
        return label
    }()
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: VocaViewController.self, action: #selector(addButtonTapped))
    
    var totalWordCount: Int {
        return coreDataManager.fetch(id: vocabularyID)?.words?.count ?? 0
    }
    
    var coreDataManager = VocabularyRepository.shared
    let vocabularyID: NSManagedObjectID
    var filteredWord: [WordEntity] = []

    init(vocabularyID: NSManagedObjectID) {
        self.vocabularyID = vocabularyID
        print("!!!init\(vocabularyID)")
        super.init(nibName: nil, bundle: nil)
        
        allLabel.text = "전체 단어수: \(totalWordCount)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        view.backgroundColor = .systemBackground
        vocaTableView.dataSource = self
        vocaTableView.delegate = self
        vocaTableView.register(VocaTableViewCell.self, forCellReuseIdentifier: VocaTableViewCell.identifier)
        navigationItem.titleView = vocaSearchBar
        vocaSearchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        allLabel.text = "전체 단어수: \(totalWordCount)"
        
        vocaTableView.reloadData()
    }
    func setUpUI() {
        view.addSubview(vocaTableView)
        view.addSubview(allLabel)
        navigationItem.rightBarButtonItem = addButton

        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        
        allLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(Constant.defalutPadding)
            make.bottom.equalTo(vocaTableView.snp.top)
        }
        vocaTableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }
    }
    
    @objc func addButtonTapped() {
        if let vocabulary = coreDataManager.fetch(id: vocabularyID) {
              let addWordVC = AddWordViewController(vocabulary: vocabulary)
              self.navigationController?.pushViewController(addWordVC, animated: true)
          }
        vocaTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredWord = coreDataManager.fetch(id: vocabularyID)?.words?.array as? [WordEntity] ?? []
        } else {
            let allWords = coreDataManager.fetch(id: vocabularyID)?.words?.array as? [WordEntity] ?? []
            filteredWord = allWords.filter { word in
                let english = word.english ?? ""
                let korean = word.korea ?? ""
                return english.contains(searchText) || korean.contains(searchText)
            }
        }
        
        vocaTableView.reloadData()
    }
    
    private func allWordCount() -> Int {
        return coreDataManager.fetch(id: vocabularyID)?.words?.count ?? 0
    }
    
}
extension VocaViewController: UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vocaSearchBar.text?.isEmpty == false {
            return filteredWord.count
        } else {
            return coreDataManager.fetch(id: vocabularyID)?.words?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VocaTableViewCell.identifier, for: indexPath) as! VocaTableViewCell
        // TODO: - 작업해야함
//        let wordsToDisplay: [WordEntity]
//        if vocaSearchBar.text?.isEmpty == false {
//            wordsToDisplay = filteredWord
//        } else {
//            wordsToDisplay = coreDataManager.fetch(id: vocabularyID)?.words?.array as? [WordEntity] ?? []
//        }
//

        cell.bind(vocabularyID: vocabularyID, index: indexPath.row)
        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
        print("text")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVocaViewController = SelectedVocaViewController()
        guard let voca = coreDataManager.fetch(id: vocabularyID)?.words?.array as? [WordEntity] else {return}
        selectedVocaViewController.bind(data: voca, index: indexPath.row)
        
        self.navigationController?.pushViewController(selectedVocaViewController, animated: true)
    }
}
