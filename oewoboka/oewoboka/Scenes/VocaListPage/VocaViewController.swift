//
//  VocaViewController.swift
//  oewoboka
//
//  Created by Lee on 2023/09/26.
//

import UIKit

class VocaViewController: UIViewController {
    let vocaTableView = UITableView()
    let allLabel : UILabel = {
        let label = UILabel()
        label.text = "전체 단어수: 00"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setUpUI()
//        
//        vocaTableView.dataSource = self
//        vocaTableView.delegate = self
//        vocaTableView.register(VocaListTableViewCell.self, forCellReuseIdentifier: "VocaCell")

    }
    func setUpUI() {
        self.view.addSubview(vocaTableView)
        view.addSubview(allLabel)
        allLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(vocaTableView.snp.top)
        }
        vocaTableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension VocaViewController: UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocaCell", for: indexPath) as! VocaTableViewCell
        
        return cell
    }
    
    
}
