//
//  DetailedRoomVC.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/15/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailedRoomVC: UIViewController, UIScrollViewDelegate {
    
    private let disposeBag: DisposeBag = .init()
    private let navigator: Navigator
    private let cellID: String = "CellID"
    private let fact: LovooFact?
    private var images: BehaviorRelay<[String]> = .init(value: [])
    
    private var animatebleImageView: UIImageView = .init()
    private var popImageView: UIImageView = .init()
    private let backgroundView: UIView = .init()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    init(fact: LovooFact?, navigator: Navigator) {
        self.fact = fact
        self.navigator = navigator
        super.init(nibName: "DetailedRoomVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupUI() {
        guard let fact = fact else { return }
        self.images.accept(fact.images)
        print(images.value)
        titleLabel.text = fact.title
        descriptionTextView.text = fact.text
        //collectionView.reloadData()
    }

    private func setupCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.registerNIB(ImageCell.self)
        
        images.bind(to: collectionView.rx
            .items(cellIdentifier: String(describing: ImageCell.self), cellType: ImageCell.self)) { [weak self] index, model, cell in
            cell.imageView.setImageWith(url: model)
            cell.imageViewDidTap = { [weak self] imageView in
                self?.animate(imageView: imageView)
            }
        }.disposed(by: disposeBag)
    }
    
    private func animate(imageView: UIImageView) {
        animatebleImageView = imageView
        guard let initialFrame = imageView.superview?.convert(imageView.frame, to: nil) else { return }
        popImageView.image = imageView.image
        popImageView.frame = initialFrame
        setupPopImageView()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            let height = (self.view.frame.width / initialFrame.width) * initialFrame.height
            let pointY = (self.view.frame.height - height) / 2
            self.popImageView.frame = CGRect.init(x: 0, y: pointY, width: self.view.frame.width, height: height)
            self.backgroundView.alpha = 1
        }
    }
    
    private func setupPopImageView() {
        backgroundView.frame = self.view.frame
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        view.addSubview(backgroundView)
        
        popImageView.isUserInteractionEnabled = true
        popImageView.contentMode = .scaleToFill
        let swipeGesture: UISwipeGestureRecognizer = .init(target: self, action: #selector(zoomOut))
        swipeGesture.direction = .up
        popImageView.enableZoom()
        backgroundView.addGestureRecognizer(swipeGesture)
        view.addSubview(popImageView)
    }
    
    @objc private func zoomOut() {
        guard let initialFrame = animatebleImageView.superview?
            .convert(animatebleImageView.frame, to: nil) else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.popImageView.frame = initialFrame
            self?.backgroundView.alpha = 0
        }) { [weak self] _ in
            self?.popImageView.removeFromSuperview()
            self?.backgroundView.removeFromSuperview()
            self?.animatebleImageView.alpha = 1
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigator.pop()
    }
    
}

extension DetailedRoomVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
