//
//  MoreViewModel.swift
//  NewsApp
//
//  Created by serdar on 19.05.2023.
//

import Foundation

extension MoreViewModel {
    fileprivate enum Constants{
        static let cornerRadius: Double = 10
        static let masksToBounds: Bool = true
        static let shadowOffset: (width: Int, height: Int) = (3,3)
        static let shadowOpacity: Float = 0.2
        static let shadowRadius: Double = 6
    }
    
}

protocol MoreViewModelProtocol {
    var delegate: MoreViewModelDelegate? { get set }
    var cornerRadius: Double { get }
    var masksToBounds: Bool { get }
    var shadowOffset: (width: Int, height: Int) { get }
    var shadowOpacity: Float{ get }
    var shadowRadius: Double { get }
}

protocol MoreViewModelDelegate: AnyObject{
    
}

final class MoreViewModel{
    weak var delegate: MoreViewModelDelegate?
    
    
}

extension MoreViewModel: MoreViewModelProtocol{
    
    var cornerRadius: Double {
        Constants.cornerRadius
    }
    
    var masksToBounds: Bool {
        Constants.masksToBounds
    }
    
    var shadowOffset: (width: Int, height: Int) {
        Constants.shadowOffset
    }
    
    var shadowOpacity: Float {
        Constants.shadowOpacity
    }
    
    var shadowRadius: Double {
        Constants.shadowRadius
    }
    
}
