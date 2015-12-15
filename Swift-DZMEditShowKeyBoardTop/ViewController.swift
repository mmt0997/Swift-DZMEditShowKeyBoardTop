//
//  ViewController.swift
//  Swift-DZMEditShowKeyBoardTop
//
//  Created by haspay on 15/12/11.
//  Copyright © 2015年 DZM. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var scrollViewOne: UIScrollView!
   
    @IBOutlet weak var scrollViewTwo: UIScrollView!
   
    @IBOutlet weak var viewTwo: UIView!
   
    @IBOutlet weak var textFieldOne: UITextField!
    
    @IBOutlet weak var textFieldTwo: UITextField!
   
    @IBOutlet weak var textFieldThree: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var clickTetxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加通知
        DZMEditShowKeyBoardTop.addKeyBoardNotification(self)
        
        // 这个是一个轻量级的弹键盘小三方 IQ那个框架会出现这个效果所达不到的效果(也可能是我没找到)
        // 必须 实在滚动控件上得控件才能有效
        // IQ会在多个滚动控件嵌套时 滚动第一个检测到得滚动控件 那样一般都不会使我们要的效果 我们一般都会只需要用根滚动控件弹动
    }

    
    // 实现需要用到的通知
    // 键盘开始显示
    func keyboardWillShowNotification(notification : NSNotification){
        // 我只是写个示例 你想滚要哪个滚动控件有效就传哪个
        // 多个滚动控件嵌套 但我只需要scrollViewOne 滚动 别的scrollView上的子控件弹出键盘也只需要滚动scrollViewOne
        DZMEditShowKeyBoardTop .keyboardShowWithNotification(notification, scrollView: self.scrollViewOne, maxY: DZMEditShowKeyBoardTop.editShowKeyBoardTop.maxY)
    }
    
    
    // 键盘开始隐藏
    func keyboardWillHideNotification(notification : NSNotification){
        
        DZMEditShowKeyBoardTop .keyboardHideWithNotification(notification)
    }
    
    
    
    // UITextFieldDelegate UITextViewDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        // 在键盘未出来之前 初始化MaxY 可以在当前控制器任何子控件文件中初始化
        if textField.tag == 55{ // 谈到viewTwo
            
            DZMEditShowKeyBoardTop.maxYWithView(self.viewTwo)
        }else{
            
            DZMEditShowKeyBoardTop.maxYWithView(textField)
        }
        
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        // 在键盘未出来之前 初始化MaxY 可以在当前控制器任何子控件文件中初始化
        DZMEditShowKeyBoardTop.maxYWithView(textView)
        
        return true
    }
    
    
    // 点击蓝色view退下键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

