//
//  ViewController.swift
//  ExLog
//
//  Created by Jirokichi on 07/31/2018.
//  Copyright (c) 2018 Jirokichi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "x.x"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "xx"
        
        versionLabel.text = "\(version)(\(build))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

