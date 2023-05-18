//
//  ViewController.swift
//  NewsApp
//
//  Created by serdar on 17.05.2023.
//

import UIKit


final class HomeViewController: UIViewController, LoadingShowable {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sectionsCollectionView: UICollectionView!
    
    //for segue
    var imageURL: String?
    var readMoreURL: String?
    var titleString: String?
    var desc: String?
    var date: String?
    var writerName: String?
    
    
    var homeViewModel: HomeViewModelProtocol!{
        didSet {
            homeViewModel.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.fetchNewsData(0)
        sectionsCollectionView.register(cellType: SectionCell.self)
        collectionView.register(cellType: NewsCell.self)
        configure()
    }
    
    func configure(){
        // Başlık metni
        self.title = "The New York Times"
    }
    
         
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
        LoadingView.shared.handleOrientationChange()
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
            return homeViewModel.numberOfNewsItem
        } else if collectionView == self.sectionsCollectionView {
            return homeViewModel.numberOfSectionsItem
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()

        if collectionView == self.collectionView {
            if let news = self.homeViewModel.newsAt(indexPath.row){
                let cell = collectionView.dequeCell(cellType: NewsCell.self, indexPath: indexPath)
                cell.configure(news: news)
                cell.layer.cornerRadius = 8
                cell.layer.masksToBounds = true
                return cell
            }
            
        } else if collectionView == self.sectionsCollectionView {
            
            if let section = self.homeViewModel.sectionAt(indexPath.row){
                let cell = collectionView.dequeCell(cellType: SectionCell.self, indexPath: indexPath)
                cell.configure(section: section)
                if(section == homeViewModel.selectedSectionItem){
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
            
            
        }
        
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.sectionsCollectionView{
            return CGSize(
                width: homeViewModel.calculateSectionCellSize(indexPath.row).width,
                height: homeViewModel.calculateSectionCellSize(indexPath.row).height
            )
        }
        return CGSize(width: collectionView.frame.size.width, height: homeViewModel.heightOfNewsCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(
            top: homeViewModel.cellPaddings.top,
            left: homeViewModel.cellPaddings.left,
            bottom: homeViewModel.cellPaddings.bottom,
            right: homeViewModel.cellPaddings.right
        )
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let news = homeViewModel.newsAt(indexPath.row)
            let originalString = (news?.publishedDate ?? "" ) as String
            let substring = originalString.prefix(10)
            self.date = String(substring)
            self.titleString = news?.title
            self.writerName = news?.byline
            
            self.desc = news?.abstract
            self.imageURL = news?.multimedia?[1].url ?? ""
            self.readMoreURL = news?.url
            performSegue(withIdentifier: "Details", sender: indexPath)
            
        } else if collectionView == self.sectionsCollectionView {
            homeViewModel.fetchNewsData(indexPath.row)
        }
        
    }
}

extension HomeViewController: HomeViewModelDelegate{
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func reloadData() {
        collectionView.reloadData()
        sectionsCollectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    
}
