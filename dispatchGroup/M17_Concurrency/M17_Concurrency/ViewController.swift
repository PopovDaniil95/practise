
//
//  ViewController.swift
//  M17_Concurrency
//
//  Created by Maxim NIkolaev on 08.12.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let service = Service()
    var images: [UIImage] = []
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 20
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 140, height: 140))
        return view
    }()
    
    private func setupViews() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview()
        }
        stackView.addArrangedSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        onLoad()
    }
    
    private func onLoad() {
        let dispatchGroup = DispatchGroup()
        for _ in 0...4 {
            dispatchGroup.enter()
            service.getImageURL { urlString, error in
                guard let urlString = urlString else {
                    return
                }
                guard let image = self.service.loadImage(urlString: urlString) else {return}
                self.images.append(image)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            for i in 0...4 {
           let imageView1: UIImageView = {
                let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                view.contentMode = .scaleAspectFit
                return view
           }()
            guard let self1 = self else { return }
            self1.activityIndicator.stopAnimating()
            self1.stackView.removeArrangedSubview(self1.activityIndicator)
                self1.stackView.addArrangedSubview(imageView1)

                imageView1.image = self?.images[i]
            };()
        }
    }
}
