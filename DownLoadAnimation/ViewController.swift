//
//  ViewController.swift
//  17Animation
//
//  Created by franze on 2017/5/27.
//  Copyright © 2017年 franze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var testView:animation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfiguration()
    }
    
    func viewConfiguration(){
        testView = animation(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        testView.initialize()
        testView.center = view.center
        testView.addTarget(self, action: #selector(play), for: .touchUpInside)
        view.addSubview(testView)
    }

    @IBAction func play(_ sender: UIButton) {
        if !sender.isSelected{
            testView.start()
            sender.isSelected = !sender.isSelected
        }else{
            testView.reLayer.removeFromSuperlayer()
            testView.circle.removeFromSuperlayer()
            testView.lshape.removeFromSuperlayer()
            testView.initialize()
            sender.isSelected = !sender.isSelected
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

