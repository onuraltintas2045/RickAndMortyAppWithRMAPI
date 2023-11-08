//
//  CharacterDetailViewController.swift
//  anotherRM
//
//  Created by Onur on 2.09.2023.
//

import Foundation
import UIKit
import SnapKit

class CharacterDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let characterDetailViewModel = CharacterDetailViewModel()
    let selectedCharacter: Character
    var willDisplayEpisodes: [String] = []
    var displayedEpisodes: [String] = []
    let displayEpisodesPerPage = 10
    var displayEpisodeCurrentPage = 1
    var isLoadingData = false
    var isEpisodeTableViewHidden = true
    let episodeTableViewfooterView = UIView()
    let episodeTableViewActivityIndicator = UIActivityIndicatorView(style: .medium)
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 55
        return imageView
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var episodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.titleLabel?.textAlignment = .center
        button.setTitle("Episode               ▼", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var episodeTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cellİdentifier")
        return tableView
    }()
    init(character: Character) {
        self.selectedCharacter = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        episodeTableViewActivityIndicator.color = .white
        setupDetailViews()
        self.fillViews()
        episodeButton.addTarget(self, action: #selector(episodeButtonTapped), for: .touchUpInside)
        episodeTableView.isHidden = true
        episodeTableView.frame.size.height = 0
        episodeTableView.alpha = 0.0
        episodeTableView.delegate = self
        episodeTableView.dataSource = self
        getPageFromEpisodeAPI()
    }
    
    private func setupDetailViews(){
        view.addSubview(nameLabel)

        view.addSubview(characterImageView)
        view.addSubview(statusLabel)
        view.addSubview(genderLabel)
        view.addSubview(episodeButton)
        view.addSubview(episodeTableView)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
            
        characterImageView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(30)
            make.leading.equalTo(nameLabel.snp.leading)
            make.width.equalTo(110)
            make.height.equalTo(105)
        }
            
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(characterImageView.snp.top).offset(30)
            make.leading.equalTo(characterImageView.snp.trailing).offset(20)
        }
            
        genderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(10)
            make.leading.equalTo(statusLabel.snp.leading)
        }
            
        episodeButton.snp.makeConstraints { (make) in
            make.top.equalTo(characterImageView.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.width.equalTo(view.safeAreaLayoutGuide.layoutFrame.width - 50)
            make.height.equalTo(50)
        }
            
        episodeTableView.snp.makeConstraints { (make) in
            make.top.equalTo(episodeButton.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.width.equalTo(view.safeAreaLayoutGuide.layoutFrame.width - 50)
            make.height.equalTo(view.safeAreaLayoutGuide.layoutFrame.height / 2 - 10)
        }


    }
    
    private func getPageFromEpisodeAPI(){
        characterDetailViewModel.getPageFromEpisodeAPI(){
            self.getDataFromEpisodeAPI()
        }
    }
    
    
    
    private func getDataFromEpisodeAPI(){
        characterDetailViewModel.getDataFromEpisodeAPI(characterId: self.selectedCharacter.id) {
            self.willDisplayEpisodes.append(contentsOf: self.characterDetailViewModel.episodeNames)
            self.firstLoadTableView()
        }
    }
    
    private func fillViews(){
        nameLabel.text = selectedCharacter.name
        statusLabel.text = "\(selectedCharacter.status), \(selectedCharacter.species)"
        genderLabel.text = selectedCharacter.gender
        if let imageUrl = URL(string: selectedCharacter.image){
            characterImageView.loadImage(url: imageUrl)
        }
    }
    
    @objc func episodeButtonTapped() {
        if isEpisodeTableViewHidden {
            episodeButton.setTitle("Episode               ▲", for: .normal)
            UIView.animate(withDuration: 1.0, animations: {
                self.episodeTableView.alpha = 1.0
                self.episodeTableView.isHidden = false
                self.episodeTableView.frame.size.height = self.view.safeAreaLayoutGuide.layoutFrame.height / 2 - 10
            }) { (_) in
                
            }
            isEpisodeTableViewHidden = false
        } else {
            episodeButton.setTitle("Episode               ▼", for: .normal)
            UIView.animate(withDuration: 1.0, animations: {
                self.episodeTableView.alpha = 0.0
            }) { (_) in
                self.episodeTableView.isHidden = true
                self.episodeTableView.frame.size.height = 0
            }
            
            isEpisodeTableViewHidden = true
        }
            
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height && !isLoadingData && willDisplayEpisodes.count != displayedEpisodes.count {
            isLoadingData = true
            loadNextPage()
        }
        
    }
    
    func loadNextPage(){
        let startIndex = (displayEpisodeCurrentPage - 1) * displayEpisodesPerPage
        let endIndex = min(displayEpisodeCurrentPage * displayEpisodesPerPage, willDisplayEpisodes.count)
        episodeTableViewfooterView.frame = CGRect(x: 0, y: 0, width: episodeTableView.bounds.size.width, height: 60)
        episodeTableViewActivityIndicator.center = CGPoint(x: episodeTableViewfooterView.bounds.size.width / 2, y: episodeTableViewfooterView.bounds.size.height / 2)
        episodeTableViewfooterView.addSubview(episodeTableViewActivityIndicator)
        episodeTableViewActivityIndicator.startAnimating()
        episodeTableView.tableFooterView = episodeTableViewfooterView
        
        if startIndex < endIndex {
            let newData = Array(willDisplayEpisodes[startIndex..<endIndex])
            displayedEpisodes += newData
            displayEpisodeCurrentPage += 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.isLoadingData = false
            self.episodeTableViewActivityIndicator.stopAnimating()
            self.episodeTableView.tableFooterView = nil
            self.episodeTableView.reloadData()
        }
    }
    func firstLoadTableView(){
        let startIndex = (displayEpisodeCurrentPage - 1) * displayEpisodesPerPage
        let endIndex = min(displayEpisodeCurrentPage * displayEpisodesPerPage, willDisplayEpisodes.count)
        if startIndex < endIndex {
            let tempForDisplayedEpisodeArray = Array(willDisplayEpisodes[startIndex..<endIndex])
            displayedEpisodes += tempForDisplayedEpisodeArray
            displayEpisodeCurrentPage += 1
        }
        isLoadingData = false
        episodeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = episodeTableView.dequeueReusableCell(withIdentifier: "Cellİdentifier", for: indexPath)
        let data = displayedEpisodes[indexPath.row]
        cell.backgroundColor = .gray
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = "Episode = \(data)"
        return cell
    }
    
    
    
}
