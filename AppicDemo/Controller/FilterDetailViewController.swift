//
//  FilterDetailViewController.swift
//  AppicDemo
//
//  Created by webwerks on 10/02/23.
//

import UIKit


protocol FilterDataProtocol: AnyObject {
    func didFilterData(keyName: String, filteredData: [String])
}

class FilterDetailViewController: UIViewController {

    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var applyBtn: UIButton!
    
    var arr = [String]()
    var checkArr = [String]() {
        didSet {
            if checkArr.count > 0 {
                applyBtn.isEnabled = true
                applyBtn.backgroundColor = UIColor(red: 19/255, green: 120/255, blue: 224/255, alpha: 1.0)
            }
            else {
                applyBtn.isEnabled = false
                applyBtn.backgroundColor = UIColor.lightGray
            }
        }
    }
    var searchArr = [String]()
    var isSearching = false
    var headerTitle = String()
    weak var delegate: FilterDataProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "FilterDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterDetailTableViewCell")
        self.checkArr = arr
        navTitle.text = "Select \(headerTitle)"
        searchbar.placeholder = "Search for \(headerTitle)"
        searchbar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tblViewHeightConstraint.constant = CGFloat(65 * self.arr.count)
    }

    @IBAction func dismissVcBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectAllBtnTapped(_ sender: UIButton) {
        let newArr = isSearching ? searchArr : arr
        if checkArr.count == newArr.count {
            checkArr.removeAll()
            selectAllBtn.setImage(UIImage(named: "checkBox-OFF"), for: .normal)
        }
        else {
            checkArr = newArr
            selectAllBtn.setImage(UIImage(named: "checkBox-ON"), for: .normal)
        }
        self.tblView.reloadData()
    }
    
    @IBAction func clearBtnTapped(_ sender: UIButton) {
        checkArr.removeAll()
        selectAllBtn.setImage(UIImage(named: "checkBox-OFF"), for: .normal)
        self.tblView.reloadData()
    }
    
    @IBAction func applyBtnTapped(_ sender: UIButton) {
        delegate?.didFilterData(keyName: self.headerTitle, filteredData: self.checkArr)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func checkUncheckBtnTapped(sender: UIButton) {
        let newArr = isSearching ? searchArr : arr
        let val = newArr[sender.tag]
        if checkArr.contains(val) {
            checkArr.removeAll(where: { $0 == val })
        }
        else {
            checkArr.append(val)
        }
        let imageName = checkArr.count == newArr.count ? "checkBox-ON" : "checkBox-OFF"
        selectAllBtn.setImage(UIImage(named: imageName), for: .normal)
        self.tblView.reloadData()
    }
}

extension FilterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let newArr = isSearching ? searchArr : arr
        return newArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterDetailTableViewCell", for: indexPath) as! FilterDetailTableViewCell
        cell.selectionStyle = .none
        let newArr = isSearching ? searchArr : arr
        cell.nameLbl.text = newArr[indexPath.row]
        if checkArr.contains(newArr[indexPath.row]) {
            cell.checkUnchekBtn.setImage(UIImage(named: "checkBox-ON"), for: .normal)
        }
        else {
            cell.checkUnchekBtn.setImage(UIImage(named: "checkBox-OFF"), for: .normal)
        }
        cell.checkUnchekBtn.tag = indexPath.row
        cell.checkUnchekBtn.addTarget(self, action: #selector(checkUncheckBtnTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension FilterDetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchArr = arr.filter({ $0.range(of: searchBar.text ?? "", options: [ .caseInsensitive, .diacriticInsensitive ]) != nil })
        if searchBar.text?.count == 0 {
            isSearching = false
//            checkArr = arr
        }
//        checkArr = searchArr
        self.tblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        self.tblView.reloadData()
    }
}
