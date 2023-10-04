//
//  VocaListSelectedController.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/10/01.
//

import UIKit
import SnapKit

final class VocaListSelectedController: UIViewController {

    private let topView = PageTopView(title: "단어장 선택")
    
    let tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        return view
    }()
    
    let manager = VocabularyRepository.shared
    
    var viewModel: FTOPViewModel
    
    init(viewModel: FTOPViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VocaListSelectedController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUp()
        viewModel.vocaList.bind { [weak self] list in
            guard let self = self else {return}
            if list.isEmpty {
                viewModel.rangeBTtitle.value = "단어장 선택"
            } else {
                viewModel.rangeBTtitle.value = "총 \(viewModel.vocaList.value.count)개의 단어장"
            }
        }
    }
}

private extension VocaListSelectedController {
    func setUp() {
        setUpTopView()
        setUpCollectionView()
    }
    func setUpTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        topView.buttonDelegate = self
    }
    func setUpCollectionView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.register(VocaListTableViewCell.self, forCellReuseIdentifier: VocaListTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension VocaListSelectedController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.allFetch().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VocaListTableViewCell.identifier) as! VocaListTableViewCell
        let data = manager.allFetch()
        cell.bind(data: data[indexPath.row])
        if viewModel.vocaList.value.contains(data[indexPath.row]){
            cell.setButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            cell.setButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! VocaListTableViewCell
        print(indexPath.row)
        let data = manager.allFetch()
        if viewModel.vocaList.value.contains(data[indexPath.row]) {
            let targetIndex = viewModel.vocaList.value.firstIndex(of: data[indexPath.row])!
            viewModel.vocaList.value.remove(at: targetIndex)
            cell.setButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            viewModel.vocaList.value.append(data[indexPath.row])
            cell.setButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        }
        print(viewModel.vocaList)
        
    }
}

extension VocaListSelectedController: ViewHasButton {
    func didTappedButton(button: UIButton) {
        self.dismiss(animated: true)
    }
}
