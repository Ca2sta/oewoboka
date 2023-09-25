//
//  VocaViewController.swift
//  oewoboka
//
//  Created by Lee on 2023/09/25.
//

import UIKit
import SnapKit

class VocaViewController: UIViewController {
    
    let vocaTableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        vocaTableView.delegate = self
        vocaTableView.dataSource = self
        
        vocaTableView.register(VocaListTableViewCell.self, forCellReuseIdentifier: "VocaCell")
        
    }
    
    func setUpUI() {
        self.view.addSubview(vocaTableView)
        
        vocaTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.bottom.equalToSuperview()
            //            make.edges.equalToSuperview()
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
}

extension VocaViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocaCell", for: indexPath) as! VocaTableViewCell
   
         return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}
