//
//  HomeViewController.swift
//  AppicDemo
//
//  Created by webwerks on 10/02/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var comapnyNameLbl: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var midListStr: UILabel!
    
    var companyArr = [String]()
    var respFilterArr = [FilterDatum]()
    var filterArrDict = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "homeCell")
        tblView.isHidden = true
        getFilterData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tblViewHeightConstraint.constant = CGFloat(45 * self.companyArr.count)
    }
    
    @IBAction func filterBtnTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterScreenViewController") as! FilterScreenViewController
        vc.filterArr = self.filterArrDict
        let selectedArr = self.respFilterArr.filter({ $0.companyName == self.comapnyNameLbl.text ?? "" })
        vc.respFilterArr = selectedArr.first
        vc.midDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func selectCompanyNameBtnTapped(_ sender: UIButton) {
        tblView.isHidden = false
    }
    
    
    func getFilterArrDict(comapnyName: String) {
        let selectedArr = self.respFilterArr.filter({ $0.companyName == comapnyName })
        if let firstElement = selectedArr.first {
            filterArrDict[Constants.accNo] = firstElement.accountList
            filterArrDict[Constants.brand] = firstElement.brandList
            filterArrDict[Constants.location] = firstElement.locationList
        }
    }
    
    func getFilterData() {
        guard let path = Bundle.main.url(forResource: "JsonFilter", withExtension: "json") else { return }
        if let data = NSData(contentsOf: path) {
            do {
                let resp = try JSONDecoder().decode(JSONFilterModel.self, from: data as Data)
                print(resp)
                self.companyArr = resp.filterData.map({ $0.companyName })
                self.comapnyNameLbl.text = self.companyArr[0]
                self.respFilterArr = resp.filterData
                self.getFilterArrDict(comapnyName: self.companyArr[0])
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .lightGray
        cell.textLabel?.text = companyArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        comapnyNameLbl.text = companyArr[indexPath.row]
        self.getFilterArrDict(comapnyName: companyArr[indexPath.row])
        tblView.isHidden = true
    }
    
}

extension HomeViewController: MIDListProtocol {
    func didPassMIDList(list: [String]) {
        self.midListStr.text = list.joined(separator: ", ")
    }
    
    
}
