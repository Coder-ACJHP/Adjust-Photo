//
//  ViewController.swift
//  AdjustPhoto
//
//  Created by Onur Işık on 27.11.2018.
//  Copyright © 2018 Onur Işık. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var beforeAfterBtn: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var masterImageView: UIImageView!
    
    var filter: CIFilter!
    var tempImage: UIImage!
    var nameList = [String]()
    var imageList = [UIImage]()
    var filterNameAsString: String = "BLUR"
    let editingImage = UIImage(named: "girl")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imageList = ContentProvider.getImageContent()
        nameList = ContentProvider.getNamesContent()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        blurEffectView.effect = nil
        
        masterImageView.contentMode = .scaleAspectFit
        masterImageView.image = editingImage
        
    }
    
    
    fileprivate func getFilterName(name:String) {
        switch name {
        case "BLUR":
            filter = CIFilter(name: "CIGaussianBlur")
        case "BRIGTNESS":
            filter = CIFilter(name: "CIColorControls")
        case "CONTRAST":
            filter = CIFilter(name: "CIColorControls")
        case "HIGHLIGHT":
            filter = CIFilter(name: "CIHighlightShadowAdjust")
        case "SHADOW":
            filter = CIFilter(name: "CIHighlightShadowAdjust")
        case "SHARPEN":
            filter = CIFilter(name: "CISharpenLuminance")
        case "WARMTH":
            filter = CIFilter(name: "CITemperatureAndTint")
        default: break
        }
    }
    
    fileprivate func adjustFilterValue(name:String, amount: CGFloat) {
        switch name {
        case "BLUR":
            filter.setValue(amount, forKey: kCIInputRadiusKey)
        case "BRIGTNESS":
            filter.setValue(amount / 100, forKey: kCIInputBrightnessKey)
        case "CONTRAST":
            filter.setValue(amount / 10, forKey: kCIInputContrastKey)
        case "HIGHLIGHT":
            filter.setValue(amount, forKey: "inputHighlightAmount")
        case "SHADOW":
            filter.setValue(amount, forKey: "inputShadowAmount")
        case "SHARPEN":
            filter.setValue(amount / 10, forKey: kCIInputSharpnessKey)
        case "WARMTH":
            filter.setValue(amount * 100, forKey: "inputNeutral")
            filter.setValue(amount * 100, forKey: "inputTargetNeutral")
        default: break
        }
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        let amount = CGFloat(sender.value)
        
        activityView.startAnimating()
        
        let context = CIContext(options: nil)
        
        let coreImage = CIImage(cgImage: self.masterImageView.image!.cgImage!)
        
        self.getFilterName(name: self.filterNameAsString)
        self.filter.setValue(coreImage, forKey: kCIInputImageKey)
        self.adjustFilterValue(name: self.filterNameAsString, amount: amount)
        
        if let output = self.filter.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgimgresult = context.createCGImage(output, from: output.extent)
            let result = UIImage(cgImage: cgimgresult!)
            
            DispatchQueue.main.async {
                self.activityView.stopAnimating()
                self.masterImageView.image = result
            }
            
        }
    }
    
    
    @IBAction func beforeAfter(_ sender: UIButton) {
        
        tempImage = self.masterImageView.image
        self.masterImageView.image = self.editingImage
    }
    
    @IBAction func beforeAfterReleased(_ sender: UIButton) {
        self.masterImageView.image = tempImage
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        self.masterImageView.image = editingImage
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toolCell", for: indexPath) as! ToolCell
        cell.imageView.image = imageList[indexPath.item]
        cell.nameLabel.text = nameList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ToolCell
        
        if selectedCell.nameLabel.text == "BACKGROUND" {
            
            slider.isEnabled = false
            UIView.animate(withDuration: 0.3) {
                self.backgroundImageView.image = self.editingImage
                self.blurEffectView.effect = UIBlurEffect(style: .light)
            }
            
        } else {
            slider.isEnabled = true
            slider.setValue(10, animated: true)
            self.filterNameAsString = selectedCell.nameLabel.text!
        }
    }
}
