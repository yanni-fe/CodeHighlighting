//
//  TestViewController.swift
//  CodeHighlighting
//
//  Created by Yu Pengyang on 4/5/16.
//  Copyright © 2016 Caishuo. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var codeView: CodeHighlightView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let codeString = try? String(contentsOfFile: NSBundle.mainBundle().pathForResource("Test", ofType: "txt")!)
        codeView.codeString = codeString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
