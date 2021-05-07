//
//  StatusCell.swift
//  twitterclient
//
//  Created by Mospeng Research Lab Philippines on 6/1/20.
//  Copyright © 2020 Mospeng Research Lab Philippines. All rights reserved.
//

import UIKit

class StatusCell: BaseCell {
    
    var homeStatus: HomeStatus? {
        didSet {
            if let name = homeStatus?.name, let screenName = homeStatus?.screenName, let text = homeStatus?.text {
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
                attributedText.append(NSAttributedString(string: "\n@\(screenName)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
                attributedText.append(NSAttributedString(string: "\n\(text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
                self.statusTextView.attributedText = attributedText
            }
           
            if let profileImage = homeStatus?.profileImage {
                let url = URL(string: profileImage)
                URLSession.shared.dataTask(with: url!) { (data, respnse, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }.resume()
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        
        addSubview(statusTextView)
        addSubview(dividerView)
        addSubview(profileImageView)
        
//        // constraints for statusTextView
//        addConstraintsWithFormat(format: "H:|[v0]|", views: statusTextView)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: statusTextView)
//
//        // constraints for dividerView
//        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: dividerView)
//        addConstraintsWithFormat(format: "V:|[v0(1)]|", views: dividerView)
        
//        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: nameLabel)
//        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: screenNameLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0(48)]-8-[v1]|", views: profileImageView, statusTextView)
        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: dividerView)

        addConstraintsWithFormat(format: "V:|-8-[v0]-24-|", views: profileImageView)
        addConstraintsWithFormat(format: "V:|[v0][v1(1)]|", views: statusTextView, dividerView)
    }
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: .init(), metrics: nil, views: viewsDictionary))
    }
}


