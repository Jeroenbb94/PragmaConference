//
//  ViewController.swift
//  JBDiffableDataSource
//
//  Created by Jeroen Bakker on 21/09/2019.
//  Copyright © 2019 Jeroen Bakker. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    enum Section {
        case main
        case second
    }
    
    @available(iOS 13.0, *)
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Speaker>? = nil
    
    @IBOutlet weak private var collectionView: UICollectionView!
    private var speakers: [Speaker] = []
    private var cellSizes: [CGSize] = []
    private lazy var newCellSizes: [Int: CGSize] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        populateCollectionView()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            var newSpeakers: [Speaker] = []
//            for i in 1..<5 {
//                newSpeakers.append(Speaker(
//                    name: "User \(i)",
//                    twitterHandler: "@Twitter \(i)",
//                    imageURL: URL(string: "https://pragmaconference.com/assets/images/speakers/jeroen_bakker.jpg")
//                ))
//            }
//            self.populateCollectionView(with: newSpeakers)
//        }
    }
}

// MARK: - Setup
extension ViewController {
    
    func setupCollectionView() {
        collectionView.register(UINib(nibName: String(describing: SpeakerCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SpeakerCollectionViewCell.self))
        
        collectionView.register(UINib(nibName: String(describing: SpeakerCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SpeakerCollectionReusableView.self))
        
        collectionView.delegate = self
        if #available(iOS 13.0, *) {
            setupCollectionViewDataSource()
        } else {
            collectionView.dataSource = self
        }
    }
    
    @available(iOS 13.0, *)
    func setupCollectionViewDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, speaker) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SpeakerCollectionViewCell.self), for: indexPath) as? SpeakerCollectionViewCell else {
                fatalError("Could not dequeue SpeakerCollectionViewCell")
            }
            
            cell.display(viewModel: speaker)
            
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: SpeakerCollectionReusableView.self), for: indexPath) as? SpeakerCollectionReusableView else {
                fatalError("Could not dequeue SpeakerCollectionReusableView")
            }
            
            headerView.display(viewModel: "Header")
            
            return headerView
        }
    }
}
    
extension ViewController {
    
    func populateCollectionView() {
        for i in 1..<100 {
            let speaker = Speaker(
                name: "User \(i)",
                twitterHandler: "@Twitter \(i)",
                imageURL: URL(string: "https://pragmaconference.com/assets/images/speakers/jeroen_bakker.jpg")
            )
            speakers.append(speaker)
            if #available(iOS 13.0, *) {
                newCellSizes[speaker.hashValue] = CGSize(width: view.frame.width - 32, height: 62)
            } else {
                cellSizes.append(CGSize(width: view.frame.width - 32, height: 62))
            }
        }
        
        if #available(iOS 13.0, *) {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Speaker>()
            snapshot.appendSections([Section.main])
            snapshot.appendItems(self.speakers, toSection: Section.main)
            self.dataSource?.apply(snapshot)
        } else {
            collectionView.reloadData()
        }
    }
    
    func populateCollectionView(with speakers: [Speaker]) {
        let previousSpeakers = self.speakers
        self.speakers = speakers
        
        if #available(iOS 13.0, *), var snapshot = dataSource?.snapshot() {
            snapshot.deleteItems(previousSpeakers)
            snapshot.appendItems(speakers)
            dataSource?.apply(snapshot, animatingDifferences: true)
        } else {
            collectionView.performBatchUpdates({
            if previousSpeakers.count > speakers.count {
                let reloadIndexPaths = Array(0..<speakers.count).map({ IndexPath(item: $0, section: 0) })
                let deleteIndexPaths = Array(speakers.count..<previousSpeakers.count).map({ IndexPath(item: $0, section: 0) })
                collectionView.reloadItems(at: reloadIndexPaths)
                collectionView.deleteItems(at: deleteIndexPaths)
            } else if previousSpeakers.count < speakers.count {
                let reloadIndexPaths = Array(0..<previousSpeakers.count).map({ IndexPath(item: $0, section: 0) })
                let insertIndexPaths = Array(previousSpeakers.count..<speakers.count).map({ IndexPath(item: $0, section: 0) })
                collectionView.reloadItems(at: reloadIndexPaths)
                collectionView.insertItems(at: insertIndexPaths)
            } else {
               let indexPaths = Array(0..<speakers.count).map({ IndexPath(item: $0, section: 0) })
               collectionView.reloadItems(at: indexPaths)
            }
        }, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return speakers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SpeakerCollectionViewCell.self), for: indexPath) as? SpeakerCollectionViewCell else {
            fatalError("Could not dequeue SpeakerCollectionViewCell")
        }
        
        cell.display(viewModel: speakers[indexPath.item])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if #available(iOS 13.0, *), let identifier = dataSource?.itemIdentifier(for: indexPath) {
            return newCellSizes[identifier.hashValue] ?? .zero
        } else {
            return cellSizes[indexPath.item]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("Selected \(indexPath.item)")
    }
}
