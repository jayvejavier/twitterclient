//
//  CollectionViewController.swift
//  twitterclient
//
//  Created by Mospeng Research Lab Philippines on 6/1/20.
//  Copyright © 2020 Mospeng Research Lab Philippines. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    static let cellId = "cellId"
    
    var homeStatuses: [HomeStatus]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Twitter Home"
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(StatusCell.self, forCellWithReuseIdentifier: CollectionViewController.cellId)
        
        let twitter = STTwitterAPI(oAuthConsumerKey: "JyZe3A6WoxVlJp0vUHQc3RVGb", consumerSecret: "H9hl1gO4pb8BCMu5xNgM3hCxlmnwe57CLzYYXgLqELIrmIpsoX", oauthToken: "1201521241963655170-ZRm3F7oi7DZ7vn9P1B6pAOh30NtR8B", oauthTokenSecret: "HkW01Pl1wYCG0cnHSGMpbD1Dk5Nluf3brehwkwXV2tzOJ")
        twitter?.verifyCredentials(userSuccessBlock: { (username, userId) in
//            print(username, userId)
            twitter?.getHomeTimeline(sinceID: nil, count: 10, successBlock: { (statuses) in
//                print(statuses)
                self.homeStatuses = [HomeStatus]()
                
                if let statusesData = statuses as? [NSDictionary] {
                    for status in statusesData {
//                        print(text)
                        let text = status["text"] as? String
                        if let user = status["user"] as? NSDictionary {
//                            print(user)
                            let profileImage = user["profile_image_url_https"] as? String
//                            print(profileImage)
                            let name = user["name"] as? String
//                            print(name)
                            let screenName = user["screen_name"] as? String
//                            print(screenName)
                            
                            self.homeStatuses?.append(HomeStatus(text: text, profileImage: profileImage, name: name, screenName: screenName))
                        }
                    }
                }
                // The reason why the app didn't crash because getHomeTimeline method was alrady called in the main thread
                self.collectionView.reloadData()
                
            }, errorBlock: { (error) in
                print(error!)
            })
        }, errorBlock: { (error) in
            print(error!)
        })
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let homeStatus = self.homeStatuses?[indexPath.item] {
            if let name = homeStatus.name, let screenName = homeStatus.screenName, let text = homeStatus.text {
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
                attributedText.append(NSAttributedString(string: "\n@\(screenName)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
                attributedText.append(NSAttributedString(string: "\n\(text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
                
                let size = attributedText.boundingRect(with: CGSize(width: view.frame.width - 80, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), context: nil).size
                return CGSize(width: view.frame.width, height: size.height + 20)
            }
        }
        return CGSize(width: view.frame.width, height: 80)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = homeStatuses?.count {
//            print(count)
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let statusCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewController.cellId, for: indexPath) as! StatusCell
        if let homeStatus = homeStatuses?[indexPath.item] {
//            statusCell.statusTextView.text = "Twitter Status Update \(indexPath.item)"
//            statusCell.statusTextView.text = homeStatus.text
            statusCell.homeStatus = homeStatus
            
        }
        return statusCell
    }

}

