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
    
    @IBOutlet weak var randomTestButton: UIButton!
    
    var selectedButtonItemIndex = 0
    
    var buttonItems:[(ButtonType,Int)]?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "题型自测"

        // Do any additional setup after loading the view.
        randomTestButton.layer.cornerRadius = 5.0
        setUpButtons()
        for item in buttonItems! {
            print(item.0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func button1Click(_ sender: AnyObject) {
        buttonClickActionForButtonItem(0)
    }

    @IBAction func button2Click(_ sender: AnyObject) {
        buttonClickActionForButtonItem(1)
    }


    @IBAction func button3Click(_ sender: AnyObject) {
        buttonClickActionForButtonItem(2)
    }
    
    
    @IBAction func button4Click(_ sender: AnyObject) {
        buttonClickActionForButtonItem(3)
    }


    @IBAction func button5Click(_ sender: AnyObject) {
        buttonClickActionForButtonItem(4)
    }
    
    @IBAction func button6Click(_ sender: AnyObject) {
        buttonClickActionForButtonItem(5)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func buttonClickActionForButtonItem(_ itemIndex:Int) {
        self.selectedButtonItemIndex = itemIndex
        buttonItems![itemIndex].1 += 1
        self.countButtonClick(buttonItems![itemIndex].0.rawValue, value: buttonItems![itemIndex].1)
        self.performSegue(withIdentifier: "showTestWebViewSegue", sender: self)
    }
    
    func setUpButtons(){
        
        
        let unSortedButtonItems = retireveButtonCountData()
        buttonItems = unSortedButtonItems.sorted(by: {$0.1>$1.1})
        
        
        button1.labelText = buttonItems![0].0.rawValue
        button1.buttonImg = UIImage(named:buttonItems![0].0.rawValue)
        button2.labelText = buttonItems![1].0.rawValue
        button2.buttonImg = UIImage(named:buttonItems![1].0.rawValue)
        button3.labelText = buttonItems![2].0.rawValue
        button3.buttonImg = UIImage(named:buttonItems![2].0.rawValue)
        button4.labelText = buttonItems![3].0.rawValue
        button4.buttonImg = UIImage(named:buttonItems![3].0.rawValue)
        button5.labelText = buttonItems![4].0.rawValue
        button5.buttonImg = UIImage(named:buttonItems![4].0.rawValue)
        button6.labelText = buttonItems![5].0.rawValue
        button6.buttonImg = UIImage(named:buttonItems![5].0.rawValue)
        
        
    }
    
    func retireveButtonCountData() -> [(ButtonType,Int)] {
        
        var retirvedButtonItems = [(ButtonType,Int)]()
        
        
        retirvedButtonItems.append((.GuiNaZongJie,getUserDefaultsValueForKey("总结归纳段落")))
        retirvedButtonItems.append((.YueDuPaiXu,getUserDefaultsValueForKey("阅读排序")))
        retirvedButtonItems.append((.XieZuoGaoFen,getUserDefaultsValueForKey("写作高分范文")))
        retirvedButtonItems.append((.DuanLuoLangDu,getUserDefaultsValueForKey("段落朗读")))
        retirvedButtonItems.append((.TuPianMiaoShu,getUserDefaultsValueForKey("图片描述")))
        retirvedButtonItems.append((.DuanWenTi,getUserDefaultsValueForKey("短问题回答")))
        return retirvedButtonItems

    }
    
    func countButtonClick(_ button:String,value:Int) {
        UserDefaults.standard.set(value, forKey: button)
        
    }
    func getUserDefaultsValueForKey(_ key:String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
//    func sortButtonItemsArray(oldItems:[(ButtonType,Int)]) -> [(ButtonType,Int)]{
//        return oldItems.sortInPlace({$0.1>$1.1})
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTestWebViewSegue" {
            let destnationVC = segue.destination as! SelTestDBTableViewController

            
            let buttonType = buttonItems![selectedButtonItemIndex].0
            switch buttonType {
            case .GuiNaZongJie: destnationVC.categoryId = 129
            case .YueDuPaiXu: destnationVC.categoryId = 196
            case .XieZuoGaoFen: destnationVC.categoryId = 68
            case .DuanLuoLangDu: destnationVC.categoryId = 200
            case .TuPianMiaoShu: destnationVC.categoryId = 132
            case .DuanWenTi: destnationVC.categoryId = 201
            }
            
            
            
            destnationVC.navigationItem.title = buttonItems![selectedButtonItemIndex].0.rawValue
            
        }
        if segue.identifier == "radomTestSegue" {
            let destinationVC = segue.destination as! SelfTestDBWebViewController
            destinationVC.categoryId = 166
            destinationVC.navigationItem.title = "随机出题"
        }
    }
    
    func getCateIdByItemIndex (_ index:Int) {
        
    }

}
