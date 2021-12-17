//
//  ViewController.swift
//  Challenge11
//
//  Created by Pavel Ilyutchenko on 13.12.2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView!
    
    let progressBar = UIProgressView()
    let levelLabel = UILabel()
    let recordLabel = UILabel()
    
    let rows: Int = 4
    let cols: Int = 4
    let updateTime: Float = 0.5
    let firstLevelTime: Float = 60.0
    let levelDegradation: Float = 0.9
    
    var systemImageNames: [String]!
    
    var selectedCell: CardViewCell?
    var lock: Bool!
    var pairs: Int!
    var timer: Timer!
    var levelTime: Float!
    var level: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLevel()
    }
    
    func setupLevel() {
        lock = false
        pairs = 8
        levelTime = firstLevelTime * pow(levelDegradation, Float(level))
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 85, height: 85)
        
        updateRecord()
        
        collectionView = UICollectionView(frame: CGRect(x: 5, y: view.frame.size.height / 2 - 200, width: view.frame.size.width - 10, height: 400), collectionViewLayout: layout)
        collectionView.register(CardViewCell.self, forCellWithReuseIdentifier: CardViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.addSubview(collectionView)
        
        progressBar.frame.size = CGSize(width: view.frame.size.width - 10, height: 3)
        progressBar.center = CGPoint(x: view.frame.size.width / 2, y: 150)
        progressBar.progressTintColor = .gray
        progressBar.progress = 1.0
        view.addSubview(progressBar)
        
        levelLabel.frame.size = CGSize(width: view.frame.size.width - 10, height: 20)
        levelLabel.center = CGPoint(x: view.frame.size.width / 2, y: 100)
        levelLabel.font = UIFont(name: "Chalkduster", size: 20)
        levelLabel.textAlignment = .center
        levelLabel.textColor = .gray
        levelLabel.text = "Level \(level + 1)"
        view.addSubview(levelLabel)
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(updateTime), target: self, selector: #selector(progressUpdate), userInfo: nil, repeats: true)
        
        systemImageNames = ["airplane", "house", "car", "tram", "ferry", "bicycle", "scooter", "figure.walk"]
        systemImageNames += systemImageNames
        systemImageNames.shuffle()
    }
    
    func updateRecord() {
        var recordValue = UserDefaults.standard.integer(forKey: "Record")
        if level > recordValue {
            UserDefaults.standard.setValue(level, forKey: "Record")
            recordValue = level
        }
        
        recordLabel.frame.size = CGSize(width: view.frame.size.width - 10, height: 20)
        recordLabel.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height - 150)
        recordLabel.font = UIFont(name: "Chalkduster", size: 20)
        recordLabel.textAlignment = .center
        recordLabel.textColor = .gray
        recordLabel.text = "Record level \(recordValue + 1)"
        view.addSubview(recordLabel)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if lock { return }

        let cell = collectionView.cellForItem(at: indexPath) as! CardViewCell
        
        if selectedCell == nil {
            selectedCell = cell
            cell.flip()
            return
        }
        
        if cell != selectedCell {
            lock.toggle()
            cell.flip()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self, weak cell] in
                if self?.selectedCell?.name! == cell?.name! {
                    self?.selectedCell?.hide()
                    cell?.hide()

                    self?.pairs -= 1
                } else {
                    self?.selectedCell?.flip()
                    cell?.flip()
                }
                
                self?.selectedCell = nil
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.lock.toggle()
                    self?.checkEndGame()
                }
            }
        } else {
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardViewCell.identifier, for: indexPath) as! CardViewCell
        cell.setImage(systemImageNames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows * cols
    }
    
    @objc func progressUpdate() {
        progressBar.progress -= updateTime / levelTime
        
        if progressBar.progress <= 0.0 {
            timer.invalidate()
            level = 0
            let ac = UIAlertController(title: "GAME OVER", message: "You lost!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.viewDidLoad()
            }))
            present(ac, animated: true)
        }
    }
    
    func checkEndGame() {
        if pairs == 0 {
            timer.invalidate()
            level += 1
            let ac = UIAlertController(title: "NEXT LEVEL", message: "You win!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.viewDidLoad()
            }))
            present(ac, animated: true)
        }
    }
    
}

