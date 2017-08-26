//
//  ViewController.swift
//  KennyYakala
//
//  Created by Kemal Aydın on 26.08.2017.
//  Copyright © 2017 Kemal Aydın. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    var highScore = UserDefaults.standard.object(forKey: "highScore")
    var second = 10
    var score = 0
    var timer = Timer()
    var gamePlay = true
    var whichKenny = 1
    let kennyImage = UIImageView()
    var kennyRand = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kennyImage.image = UIImage(named: "kenny")
        kennyImage.contentMode = .scaleAspectFit
        
        // Resimleri gesture etme
        kennyImage.isUserInteractionEnabled = true
        
        // Resimlere Tıklandığı Verilecek Aksiyon
        let gestureClick = UITapGestureRecognizer(target: self, action: #selector(ViewController.kennyWhere))
        kennyImage.addGestureRecognizer(gestureClick)
        
        
        // Eğer Daha Önce Yüksek Skor var ise Onu getir
        if let highScoreCheck = highScore as? String{
            highScoreLabel.text = "\(highScoreCheck)"
        }else{
            highScoreLabel.text = "0"
        }
        
        // Timer Çalıştır
        runTimer()
        kennyRandomFunc()
        
    }
    
    func kennyRandomFunc(){
        kennyRand = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.kennyRandom), userInfo: nil, repeats: true)
    }
    
    // Timer Fonksiyonu
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timeDown), userInfo: nil, repeats: true)
    }
    
    @objc func kennyRandom(){
        let ImageX = arc4random_uniform(236) + 16
        let ImageY = arc4random_uniform(280) + 140
        kennyImage.frame = CGRect(x: Int(ImageX), y: Int(ImageY) , width: 107, height: 107)
        view.addSubview(kennyImage)
    }
    
    @objc func kennyWhere(){
            self.score = score + 1
            self.scoreLabel.text = "Score : \(String(score))"
    }
    
    // Timer İçerisinde Çalışacak Fonksiyon
    @objc func timeDown(){
        // Saniye eğer 0 dan büyük ise
        if(second > 0){
            second = second - 1
            secondLabel.text = String(second)
        // Saniye 0 veya daha küçük ise
        }else{
            // Timer Durdur
            timer.invalidate()
            kennyRand.invalidate()
            // Oyunu Durdur
            gamePlay = false
            
            // En  yüksek Skor Kontrolü
            if (highScore as? String) != nil{
                if self.score > Int(highScoreLabel.text!)! {
                    highScoreLabel.text = "\(String(score))"
                    UserDefaults.standard.set(String(score), forKey: "highScore")
                    UserDefaults.standard.synchronize()
                }
                
            }else{
                highScoreLabel.text = "High Score : \(String(score))"
                UserDefaults.standard.set(String(score), forKey: "highScore")
                UserDefaults.standard.synchronize()
            }
            // --- en yüksek skor kontrol sonu ----
            
            // --- Oyun Bittiğinde Alert Göster ---
            let alert = UIAlertController(title: "Oyun Bitti", message: "Oyun Süresi Oldu. Yeni Oyun Başlatmak İçin Tekrar Tuşuna Basınız", preferredStyle: UIAlertControllerStyle.alert)
            let closeButton = UIAlertAction(title: "Kapat", style: UIAlertActionStyle.cancel, handler: { (closeButton) in
                exit(0)
            })
            let restartButton = UIAlertAction(title: "Tekrar", style: UIAlertActionStyle.default, handler: { (restartButton) in
                self.second = 10
                self.score = 0
                self.gamePlay = true
                self.scoreLabel.text = "Score : 0"
                self.secondLabel.text = "0"
                self.runTimer()
                self.kennyRandomFunc()
            })
            alert.addAction(closeButton)
            alert.addAction(restartButton)
            self.present(alert, animated: true, completion: nil)
            secondLabel.text = "Süre Doldu"
        }
        
        
    }


}

