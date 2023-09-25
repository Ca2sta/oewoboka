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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        setUpUI()
        
        vocaListTableView.delegate = self
        vocaListTableView.dataSource = self
        vocaListTableView.register(VocaListTableViewCell.self, forCellReuseIdentifier: "ListCell")
    }
    
    func setUpUI() {
        self.view.addSubview(vocaListTableView)
        
        vocaListTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.bottom.equalToSuperview()
//            make.edges.equalToSuperview()
        }
    }
    
    
}
extension VocaListViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! VocaListTableViewCell
        
        cell.vocaListLabel.text = "Voca List \((indexPath.row + 1))"
        cell.vocaNumbersLabel.text = "V: \(indexPath.row)"
        cell.completeNumbersLabel.text = "Com: \(indexPath.row)"
        cell.uncompleteNumbersLabel.text = "Ucm: \(indexPath.row)"
        cell.achievementRate.text = "Achievement Rate: \(indexPath.row)%"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = 150
        let spacing = 20
        return CGFloat(cellHeight + spacing)
    }
}
    
