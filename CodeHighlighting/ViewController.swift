//
//  ViewController.swift
//  CodeHighlighting
//
//  Created by Yu Pengyang on 3/29/16.
//  Copyright © 2016 Caishuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let codeString = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("Test", ofType: "txt")!)
        print(codeString.highlight("html")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

