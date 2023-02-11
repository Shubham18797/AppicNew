//
//  JsonFilterModel.swift
//  AppicDemo
//
//  Created by webwerks on 10/02/23.
//

import Foundation

// MARK: - JSONFilterModel
struct JSONFilterModel: Codable {
    let status, message, errorCode: String
    let filterData: [FilterDatum]
}

// MARK: - FilterDatum
struct FilterDatum: Codable {
    let cif, companyName: String
    let accountList, brandList, locationList: [String]
    let hierarchy: [Hierarchy]

    enum CodingKeys: String, CodingKey {
        case cif = "Cif"
        case companyName, accountList, brandList, locationList, hierarchy
    }
}

// MARK: - Hierarchy
struct Hierarchy: Codable {
    let accountNumber: String
    let brandNameList: [BrandNameList]
}

// MARK: - BrandNameList
struct BrandNameList: Codable, Equatable {
    static func == (lhs: BrandNameList, rhs: BrandNameList) -> Bool {
        lhs.brandName == rhs.brandName
    }

    let brandName: String
    let locationNameList: [LocationNameList]
}

// MARK: - LocationNameList
struct LocationNameList: Codable, Equatable {
    static func == (lhs: LocationNameList, rhs: LocationNameList) -> Bool {
        lhs.locationName == rhs.locationName
    }
    
    let locationName: String
    let merchantNumber: [MerchantNumber]
}

// MARK: - MerchantNumber
struct MerchantNumber: Codable {
    let mid: String
    let outletNumber: [String]
}
