//
//  ViewController.swift
//  NewsApp
//
//  Created by serdar on 17.05.2023.
//

import UIKit
import NewsAPI

extension HomeViewController {
    fileprivate enum Constants {
        static let cellLeftPadding: CGFloat = 10
        static let cellRightPadding: CGFloat = 10
        static let cellPosterImageRatio: CGFloat = 1/2
        static let cellTitleHeight: CGFloat = 60
    }

}

final class HomeViewController: UIViewController, LoadingShowable {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sectionsCollectionView: UICollectionView!
    
    private let service: TopNewsServiceProtocol = TopNewsService()
    private var newsList: [News] = []
    private var sectionList: [SectionAPIURL] = SectionAPIURL.allCases
    private var selectedSection: SectionAPIURL = SectionAPIURL.home
    
    //for segue
    var imageURL: String?
    var readMoreURL: String?
    var titleString: String?
    var desc: String?
    var date: String?
    var writerName: String?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
        sectionsCollectionView.register(cellType: SectionCell.self)
        collectionView.register(cellType: NewsCell.self)
        configure()
    }
    
    func configure(){
        // Başlık metni
        self.title = "The New York Times"
    }
    
     func fetchMovies(section:SectionAPIURL = SectionAPIURL.home) {
        self.showLoading()
        
        service.fetchTopNews(section: section) { [weak self] response in
            guard let self else { return }
            self.hideLoading()
            switch response {
            case .success(let news):
                self.newsList = self.filterNewsList(news)
                self.selectedSection = section
                self.collectionView.reloadData()
                self.sectionsCollectionView.reloadData()
                let indexPath = IndexPath(item: 0, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            case .failure(let error):
                print("Serdar: \(error)")
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    func filterNewsList(_ newsList: [News]) -> [News] {
        return newsList.filter { news in
            if let url = news.url, url != "null",
               let abstract = news.abstract, !abstract.isEmpty {
                return true
            } else {
                return false
            }
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Details" {
            
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Details" {
            if let destinationVC = segue.destination as? MoreViewController {
                destinationVC.titleString = self.titleString
                destinationVC.writerName =  self.writerName
                destinationVC.date =        self.date
                destinationVC.desc =        self.desc
                destinationVC.imageURL =    self.imageURL
                destinationVC.readMoreURL = self.readMoreURL
            }
           
        }
    }

}

extension HomeViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return newsList.count
        } else if collectionView == self.sectionsCollectionView {
            return sectionList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()

        if collectionView == self.collectionView {
            let cell = collectionView.dequeCell(cellType: NewsCell.self, indexPath: indexPath)
            let news = self.newsList[indexPath.row]
            cell.configure(news: news)
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            return cell
        } else if collectionView == self.sectionsCollectionView {
            let cell = collectionView.dequeCell(cellType: SectionCell.self, indexPath: indexPath)
            let section = self.sectionList[indexPath.row]
            cell.configure(section: section)
            if(section == selectedSection){
                cell.title.textColor = .black
                cell.contentView.backgroundColor = .systemYellow
            }else{
                cell.title.textColor = .white
                cell.contentView.backgroundColor = .lightGray
            }
            
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            return cell
        }
        
        
        return cell
    }
    
    private func calculateHeight() -> CGFloat {
        let cellWitdh = collectionView.frame.size.width - (Constants.cellLeftPadding + Constants.cellRightPadding)
        let posterImageHeight = cellWitdh * Constants.cellPosterImageRatio
        
        return (Constants.cellTitleHeight + posterImageHeight)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.sectionsCollectionView{
            return CGSize(width: (self.sectionList[indexPath.row] as SectionAPIURL).rawValue.count*15, height: 35)
        }
        return CGSize(width: collectionView.frame.size.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: Constants.cellLeftPadding, left: Constants.cellLeftPadding, bottom: Constants.cellLeftPadding, right: Constants.cellRightPadding)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let originalString = (newsList[indexPath.row].publishedDate ?? "") as String
            let substring = originalString.prefix(10)
            self.titleString = newsList[indexPath.row].title
            self.writerName = newsList[indexPath.row].byline
            self.date = String(substring)
            self.desc = newsList[indexPath.row].abstract
            self.imageURL = newsList[indexPath.row].multimedia?[1].url ?? ""
            self.readMoreURL = newsList[indexPath.row].url
            performSegue(withIdentifier: "Details", sender: indexPath)
            
        } else if collectionView == self.sectionsCollectionView {
            self.fetchMovies(section: self.sectionList[indexPath.row])
        }
        
    }
}

