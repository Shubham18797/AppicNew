//
//  FilterScreenViewController.swift
//  AppicDemo
//
//  Created by webwerks on 10/02/23.
//

import UIKit

protocol MIDListProtocol: AnyObject {
    func didPassMIDList(list: [String])
}

class FilterScreenViewController: UIViewController {

    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    
    var copyFilterArr = [String: Any]()
    var filterArr = [String: Any]()
    var respFilterArr: FilterDatum?
//    var accountNoList = [String]()
//    var brandNameList = [BrandNameList]()
    var locationNameList = [LocationNameList]()
//    var midArr = [String]()
    weak var midDelegate: MIDListProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FilterCollectionViewCell")
        tblView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterTableViewCell")
        copyFilterArr = filterArr
        respFilterArr?.hierarchy.forEach({ hierarchyModel in
            hierarchyModel.brandNameList.forEach { brandModel in
                locationNameList += brandModel.locationNameList
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tblViewHeightConstraint.constant = CGFloat(65 * self.filterArr.count)
    }
    
    @IBAction func clearBtnTapped(_ sender: UIButton) {
        filterArr = copyFilterArr
        self.filterCollectionView.reloadData()
        self.tblView.reloadData()
    }
    
    @IBAction func dismissFilterVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyBtnTapped(_ sender: UIButton) {
        midDelegate?.didPassMIDList(list: getMIdArr())
        self.dismiss(animated: true, completion: nil)
    }
    
    func getTitle(index: Int) -> (String, [String]) {
        var keyName = String()
        switch index {
        case 0:
            keyName = Constants.accNo
        case 1:
            keyName = Constants.brand
        case 2:
            keyName = Constants.location
        default:
            break
        }
        return (keyName, filterArr[keyName] as? [String] ?? [])
    }
    
    
    func getMIdArr() -> [String] {
        var merchantList = [MerchantNumber]()
        locationNameList.forEach { locationModel in
            merchantList += locationModel.merchantNumber
        }
        return merchantList.map({ $0.mid })
    }
    
}

extension FilterScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        let tuple = getTitle(index: indexPath.row)
        cell.filterCountLbl.text = "\(tuple.0): \(tuple.1.count)"
        return cell
    }
    
    
}

extension FilterScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tuple = getTitle(index: indexPath.row)
        let item = "\(tuple.0): \(tuple.1.count)"
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
        ])
        return CGSize(width: itemSize.width + 36, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension FilterScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
        cell.selectionStyle = .none
        let tuple = getTitle(index: indexPath.row)
        cell.filterNameLbl.text = "Select \(tuple.0)"
        cell.filterCountLbl.text = "\(tuple.1.count)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterDetailViewController") as! FilterDetailViewController
        let tuple = getTitle(index: indexPath.row)
        vc.arr = tuple.1
        vc.headerTitle = tuple.0
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension FilterScreenViewController: FilterDataProtocol {
    func didFilterData(keyName: String, filteredData: [String]) {
        guard let respFilterArr = respFilterArr else { return }
        var hierarchyArr = [Hierarchy]()
        var accountNoList = [String]()
        var brandNameList = [BrandNameList]()
        
//        respFilterArr.hierarchy.forEach { hierarchyModel in
//            (self.filterArr[Constants.brand] as? [String])?.forEach({ strName in
//                brandNameList = hierarchyModel.brandNameList.filter({ $0.brandName == strName })
//            })
//            accountNoList = (self.filterArr[Constants.accNo] as? [String])?.filter({ $0 == hierarchyModel.accountNumber }) ?? []
//        }
        
        
//        var locationNameList = [LocationNameList]()
        locationNameList.removeAll()
        
        switch keyName {
        case Constants.accNo:
            filteredData.forEach { strName in
                hierarchyArr += respFilterArr.hierarchy.filter({ $0.accountNumber == strName })
            }
            hierarchyArr.forEach { hierarchModel in
                accountNoList.append(hierarchModel.accountNumber)
                brandNameList += hierarchModel.brandNameList
            }
            brandNameList.forEach { brandModel in
                locationNameList += brandModel.locationNameList
            }
            
        case Constants.brand:
            
            respFilterArr.hierarchy.forEach { hierarchModel in
                brandNameList += hierarchModel.brandNameList
            }
            filteredData.forEach { strName in
                brandNameList = brandNameList.filter({ $0.brandName == strName })
            }
            brandNameList.forEach { brandModel in
                locationNameList += brandModel.locationNameList
                hierarchyArr = respFilterArr.hierarchy.filter {
                    return $0.brandNameList.contains { branList in
                        branList == brandModel
                    }
                }
            }
    
            hierarchyArr.forEach { hierarchModel in
                accountNoList.append(hierarchModel.accountNumber)
            }
            
            print(hierarchyArr)
//            filteredData.forEach { strName in
//                hierarchyArr = respFilterArr.hierarchy.filter {
//                    return ($0.brandNameList == ($0.brandNameList.filter({ $0.brandName == strName })))
//                }
//
//            }
//            print(brandNameList)
            
//            hierarchyArr = respFilterArr.hierarchy.filter({ $0.brandNameList == brandNameList })
//            hierarchyArr.forEach { hierarchyModel in
//                accountNoList.append(hierarchyModel.accountNumber)
//                hierarchyModel.brandNameList.forEach { brandModel in
//                    locationNameList += brandModel.locationNameList
//                }
//            }
                        
        case Constants.location:
            
            respFilterArr.hierarchy.forEach { hierarchModel in
                hierarchModel.brandNameList.forEach { brandModel in
                    locationNameList += brandModel.locationNameList
                }
            }
            filteredData.forEach { strName in
                locationNameList = locationNameList.filter({ $0.locationName == strName })
            }
            
            locationNameList.forEach { locationModel in
                hierarchyArr = respFilterArr.hierarchy.filter {
                    return $0.brandNameList.contains { branList in
                        branList.locationNameList.contains { locateM in
                            locateM == locationModel
                        }
                    }
                }
            }
            
            print(hierarchyArr)
            hierarchyArr.forEach { hierarchModel in
                accountNoList.append(hierarchModel.accountNumber)
                brandNameList += hierarchModel.brandNameList
            }
            
        default:
            break
        }
        
        self.filterArr[Constants.accNo] = accountNoList
        self.filterArr[Constants.brand] = brandNameList.map({ $0.brandName })
        self.filterArr[Constants.location] = locationNameList.map({ $0.locationName })
//        var merchantList = [MerchantNumber]()
//        locationNameList.forEach { locationModel in
//            merchantList += locationModel.merchantNumber
//        }
//        self.midArr = merchantList.map({ $0.mid })
        
//        self.filterArr[keyName] = filteredData
        self.filterCollectionView.reloadData()
        self.tblView.reloadData()
    }
    
    
}


