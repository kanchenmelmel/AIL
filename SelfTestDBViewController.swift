//
//  SelfTestDBViewController.swift
//  AIL
//
//  Created by Work on 12/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

enum ButtonType:String {
    case GuiNaZongJie = "总结归纳段落"
    case YueDuPaiXu = "阅读排序"
    case XieZuoGaoFen = "写作高分范文"
    case DuanLuoLangDu = "段落朗读"
    case TuPianMiaoShu = "图片描述"
    case DuanWenTi = "短问题回答"
}

class SelfTestDBViewController: UIViewController {

    @IBOutlet weak var button1: SelfTestDBHomeButton!
    
    
    @IBOutlet weak var button2: SelfTestDBHomeButton!
    
    @IBOutlet weak var button3: SelfTestDBHomeButton!
    
    @IBOutlet weak var button4: SelfTestDBHomeButton!
    
    @IBOutlet weak var button5: SelfTestDBHomeButton!
    
    @IBOutlet weak var button6: SelfTestDBHomeButton!
    
    
    var buttonItems:[(ButtonType,Int)]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func button1Click(sender: AnyObject) {
        buttonItems![0].1 += 1
        self.countButtonClick(buttonItems![0].0.rawValue, value: buttonItems![0].1)
        self.performSegueWithIdentifier("showTestListSegue", sender: self)
    }

    @IBAction func button2Click(sender: AnyObject) {
        buttonItems![1].1 += 1
        self.countButtonClick(buttonItems![1].0.rawValue, value: buttonItems![1].1)
        print(buttonItems![1].1)
    }


    @IBAction func button3Click(sender: AnyObject) {
    }
    @IBAction func button4Click(sender: AnyObject) {
    }
    @IBAction func button5Click(sender: AnyObject) {
    }
    @IBAction func button6Click(sender: AnyObject) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setUpButtons(){
        
        
        let unSortedButtonItems = retireveButtonCountData()
        buttonItems = unSortedButtonItems.sort({$0.1>$1.1})
        
        
        button1.labelText = buttonItems![0].0.rawValue
        button1.buttonImg = UIImage(named:buttonItems![0].0.rawValue)
        button2.labelText = buttonItems![1].0.rawValue
        button3.labelText = buttonItems![2].0.rawValue
        button4.labelText = buttonItems![3].0.rawValue
        button5.labelText = buttonItems![4].0.rawValue
        button6.labelText = buttonItems![5].0.rawValue
        
        
    }
    
    func retireveButtonCountData() -> [(ButtonType,Int)] {
        
        var retirvedButtonItems = [(ButtonType,Int)]()
        
        
        retirvedButtonItems.append((.GuiNaZongJie,getUserDefaultsValueForKey("GuiNaZongJie")))
        retirvedButtonItems.append((.YueDuPaiXu,getUserDefaultsValueForKey("YueDuPaiXu")))
        retirvedButtonItems.append((.XieZuoGaoFen,getUserDefaultsValueForKey("XieZuoGaoFen")))
        retirvedButtonItems.append((.DuanLuoLangDu,getUserDefaultsValueForKey("DuanLuoLangDu")))
        retirvedButtonItems.append((.TuPianMiaoShu,getUserDefaultsValueForKey("TuPianMiaoShu")))
        retirvedButtonItems.append((.DuanWenTi,getUserDefaultsValueForKey("DuanWenTi")))
        return retirvedButtonItems

    }
    
    func countButtonClick(button:String,value:Int) {
        NSUserDefaults.standardUserDefaults().setInteger(value, forKey: button)
        
    }
    func getUserDefaultsValueForKey(key:String) -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(key)
    }
    
//    func sortButtonItemsArray(oldItems:[(ButtonType,Int)]) -> [(ButtonType,Int)]{
//        return oldItems.sortInPlace({$0.1>$1.1})
//    }

}
