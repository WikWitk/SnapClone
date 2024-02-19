//
//  SnapVC.swift
//  CloneSnapchat
//
//  Created by Wiktor Witkowski on 10/02/2024.
//

import UIKit
import SDWebImage
import ImageSlideshow
import ImageSlideshowKingfisher





class SnapVC: UIViewController {
    
    var selectedSnap : Snap?
    
    var inputArray = [KingfisherSource]()

    @IBOutlet weak var timeLeftLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        if let snap = selectedSnap{
            
            timeLeftLbl.text = "Time: \(snap.timeDifference)"
            
            for imageUrl in snap.imageArray{
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
                
            }
            
            let imageSlide = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageSlide.backgroundColor = UIColor.white
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.gray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlide.pageIndicator = pageIndicator
            
            
            imageSlide.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlide.setImageInputs(inputArray)
            self.view.addSubview(imageSlide)
            self.view.bringSubviewToFront(timeLeftLbl)
            
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
