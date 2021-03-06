//
//  UserViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit

class UserViewController: UITableViewController {
    
    lazy var headerView: UserHeaderTableViewCell = {
        var cell = UserHeaderTableViewCell()
        cell.scanQrCodeViewController = { [weak self] vc in
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
        return cell
    }()
    
    var data = [
        ("", []),
        ("", [
            ("baseline_account_circle_black_24pt","个人中心"),
//            ("baseline_view_list_black_24pt","我的话题"),
//            ("baseline_reply_all_black_24pt","我的回复"),
            ("baseline_collections_bookmark_black_24pt","我的收藏"),
            ("baseline_settings_black_24pt","设置")
        ]),
        ("", [("baseline_warning_white_24pt","登出")])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = "我"
        self.view.backgroundColor = UIColor(CNodeColor.grayColor)
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        
        self.tableView.addSubview(headerView)
    
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "logoutCell")
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        self.tableView.tableFooterView = footerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView
        } else {
            return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [200, 0, 20][section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
            if indexPath.section == 2 {
                cell.selectionStyle = .none
                cell.textLabel?.textColor = UIColor.white
                cell.backgroundColor = UIColor.red
            }
            cell.textLabel?.text = data[indexPath.section].1[indexPath.row].1
            cell.imageView?.image = UIImage(named: data[indexPath.section].1[indexPath.row].0)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            let menuName = data[indexPath.section].1[indexPath.row].1
            if menuName == "个人中心" {
                let userCenterViewController = UserCenterViewController()
                userCenterViewController.loginname = UserDefaults.standard.string(forKey: "loginname")
                self.navigationController?.pushViewController(userCenterViewController, animated: true)
            } else if menuName == "我的收藏" {
                let collectVC = CollectTableViewController()
                self.navigationController?.pushViewController(collectVC, animated: true)
            } else if menuName == "登出" {
                UIAlertController.showConfirm(message: "确定要登出吗？") { (_) in
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    self.headerView.unbind()
                    self.tableView.reloadData()
                }
            }
        } else {
            UIAlertController.showAlert(message: "请先登录!")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
