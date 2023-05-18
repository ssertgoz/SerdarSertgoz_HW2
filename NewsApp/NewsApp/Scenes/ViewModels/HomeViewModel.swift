//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by serdar on 18.05.2023.
//

import Foundation
import NewsAPI


extension HomeViewModel {
    fileprivate enum Constants {
        static let sectionCellHeight: Double = 35
        static let sectionCellWidthFactor: Double = 15
        static let newsCellHeight: Double = 200
        static let cellLeftPadding: Double = 10
        static let cellRightPadding: Double = 10
        static let cellTopPadding: Double = 10
        static let cellBottomPadding: Double = 10
    }
}


protocol HomeViewModelProtocol{
    var delegate: HomeViewModelDelegate? { get set }
    func fetchNewsData(_ index: Int)
    var numberOfNewsItem: Int { get }
    func newsAt(_ index: Int) -> News?
    var numberOfSectionsItem: Int { get }
    func sectionAt(_ index: Int) -> SectionAPIURL?
    var selectedSectionItem: SectionAPIURL? { get }
    func calculateSectionCellSize(_ index: Int) -> (width: Double, height: Double)
    var heightOfNewsCell: Double { get }
    var cellPaddings: (top: Double, left: Double, bottom: Double, right: Double) { get }
}


protocol HomeViewModelDelegate: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func reloadData()  //MARK: do it for both section and normal collection view
}


final class HomeViewModel{
    let service: TopNewsServiceProtocol
    private var newsList: [News] = []
    private var sectionList: [SectionAPIURL] = SectionAPIURL.allCases
    private var selectedSection: SectionAPIURL = SectionAPIURL.home
    
    weak var delegate: HomeViewModelDelegate?
    
    init(service: TopNewsServiceProtocol) {
        self.service = service
    }
    
    
    fileprivate func fetchNews(_ index: Int) {
        self.delegate?.showLoadingView()
       
       service.fetchTopNews(section: sectionAt(index) ?? SectionAPIURL.home ) { [weak self] response in
           guard let self else { return }
           self.delegate?.hideLoadingView()
           switch response {
           case .success(let news):
               self.newsList = self.filterNewsList(news)
               self.selectedSection = self.sectionAt(index) ?? SectionAPIURL.home
               self.delegate?.reloadData()
           case .failure(let error):
               print("Serdar: \(error)")
           }
       }
   }
    
    
    fileprivate func filterNewsList(_ newsList: [News]) -> [News] {
        return newsList.filter { news in
            if let url = news.url, url != "null",
               let abstract = news.abstract, !abstract.isEmpty {
                return true
            } else {
                return false
            }
        }
    }

}

extension HomeViewModel: HomeViewModelProtocol{
    var cellPaddings: (top: Double, left: Double, bottom: Double, right: Double) {
        return (top: Constants.cellTopPadding, left: Constants.cellLeftPadding, bottom: Constants.cellBottomPadding, right: Constants.cellRightPadding)
    }
    
    var heightOfNewsCell: Double {
        Constants.newsCellHeight
    }
    
    func calculateSectionCellSize(_ index: Int) -> (width: Double, height: Double) {
        let height = Constants.sectionCellHeight
        let width = Double((sectionAt(index))?.rawValue.count ?? 0)*Constants.sectionCellWidthFactor
        return (width: width,height: height)
    }
    
    var numberOfSectionsItem: Int {
        sectionList.count
    }
    
    func sectionAt(_ index: Int) -> SectionAPIURL? {
        sectionList[index]
    }
    
    func newsAt(_ index: Int) -> News? {
        newsList[index]
    }
    
    var selectedSectionItem: SectionAPIURL? {
        selectedSection
    }
    
    var numberOfNewsItem: Int {
        newsList.count
    }
    
    func fetchNewsData(_ index: Int = 0) {
        fetchNews(index)
    }
    
    
}
