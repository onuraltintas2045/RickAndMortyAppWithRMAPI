//
//  ViewController.swift
//  anotherRM
//
//  Created by Onur on 1.09.2023.
//

import UIKit
import SnapKit
class CharacterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let characterViewModel = CharacterViewModel()
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    var isFetchingData = false
    var offsetY: CGFloat = 0
    var contentHeight: CGFloat = 0
    var boundsHeight: CGFloat = 0
    lazy var characterViewLabel: UILabel = {
        let label =  UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Characters"
        return label
    }()
    lazy var characterCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let characterCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        characterCollectionView.backgroundColor = .black
        characterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return characterCollectionView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupViews()
        loadingIndicator.color = .white
        loadingIndicator.center = CGPoint(x: characterCollectionView.bounds.midX, y: characterCollectionView.bounds.maxY - loadingIndicator.frame.height / 2)
        characterCollectionView.addSubview(loadingIndicator)
        getDataFromPageCountAPI()
        self.characterCollectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier)
        characterCollectionView.dataSource = self
        characterCollectionView.delegate = self
        
    }
    
    private func setupViews(){
        view.addSubview(characterViewLabel)
        view.addSubview(characterCollectionView)
        

        characterViewLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
        }
        
        characterCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(characterViewLabel.snp.bottom).offset(15)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        
    }
    
    func getDataFromPageCountAPI(){
        characterViewModel.getDataFromPageCountAPI(){
            self.getDataFromCharactersAPI()
        }
    }
    
    func getDataFromCharactersAPI(){
        characterViewModel.getDataFromCharactersAPI(){
            DispatchQueue.main.async {
                self.characterCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - 20) / 2
        let cellHeight = cellWidth * 1.35
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterViewModel.charactersWithEpisodeNumbers.count
    }
    
    /*func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("indexpathITEm = \(indexPath.item)")
        if indexPath.item == characterViewModel.charactersWithEpisodeNumbers.count - 1 {
            if characterViewModel.currentPage < characterViewModel.totalPageCount{
                characterViewModel.getDataFromCharactersAPI()
                characterViewModel.charactersSemaphore.wait()
                characterCollectionView.reloadData()
            }
        }
    }
     */
    
    /*
    func updateScrollValues() {
        offsetY = characterCollectionView.contentOffset.y
        contentHeight = characterCollectionView.contentSize.height
        boundsHeight = characterCollectionView.bounds.size.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateScrollValues()
        
        if offsetY > contentHeight - boundsHeight {
            if !isFetchingData  && characterViewModel.currentPage <= characterViewModel.totalPageCount {
                isFetchingData = true
                loadingIndicator.startAnimating()
                characterViewModel.getDataFromCharactersAPI()
                characterViewModel.charactersSemaphore.wait()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.loadingIndicator.stopAnimating()
                    self.characterCollectionView.reloadData()
                    self.isFetchingData = false
                }
                
            }
        }
    }
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier, for: indexPath) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let character = characterViewModel.charactersWithEpisodeNumbers[indexPath.item]
        
        cell.configure(with: character)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let character = characterViewModel.charactersWithEpisodeNumbers[indexPath.item]
        
        let newViewController: CharacterDetailViewController = CharacterDetailViewController(character: character)
        
        navigationController?.pushViewController(newViewController, animated: true)
        

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = characterViewModel.charactersWithEpisodeNumbers.count - 5
        if indexPath.item == lastItem {
            if characterViewModel.currentPage < characterViewModel.totalPageCount {
                loadingIndicator.startAnimating()
                characterViewModel.getDataFromCharactersAPI {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.loadingIndicator.stopAnimating()
                        self.characterCollectionView.reloadData()
                    }
                }
                
            }
        }
    }
}

