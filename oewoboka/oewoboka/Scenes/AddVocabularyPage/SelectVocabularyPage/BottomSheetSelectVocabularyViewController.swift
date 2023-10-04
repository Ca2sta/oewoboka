//
//  SelectVocabularyViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/04.
//

import UIKit
import SnapKit
final class BottomSheetSelectVocabularyViewController: BottomSheetViewController {
    
    private let topView = TopView(title: "단어장 선택")
    private let selectTableView = UITableView()
    private let vocabulary: VocabularyEntity
    private let vocabularyList: [VocabularyEntity]
    private let repository: VocabularyRepository = VocabularyRepository.shared
    private var selectIndex: Int? = nil
    
    var vocabularySelectHandler: ((VocabularyEntity) -> Void)?
    
    init(vocabulary: VocabularyEntity) {
        self.vocabulary = vocabulary
        self.vocabularyList = repository.allFetch()
        selectIndex = vocabularyList.firstIndex(of: vocabulary)
//        super.init(nibName: nil, bundle: nil)
        super.init(originY: Constant.screenHeight * 0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension BottomSheetSelectVocabularyViewController {
    func setup() {
        addViews()
        autoLayoutSetup()
        tableViewSetup()
    }
    
    func addViews() {
        view.addSubview(topView)
        view.addSubview(selectTableView)
    }
    
    func autoLayoutSetup() {
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        selectTableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func tableViewSetup() {
        selectTableView.register(VocabularyTableViewCell.self, forCellReuseIdentifier: VocabularyTableViewCell.identifier)
        selectTableView.delegate = self
        selectTableView.dataSource = self
    }
}

extension BottomSheetSelectVocabularyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocabularyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VocabularyTableViewCell.identifier, for: indexPath) as? VocabularyTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = vocabularyList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let selectIndex else { return }
        tableView.selectRow(at: IndexPath(row: selectIndex, section: 0), animated: true, scrollPosition: .none)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vocabularySelectHandler?(vocabularyList[indexPath.row])
        dismiss(animated: true)
    }
}
