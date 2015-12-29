//
//  DZMEditShowKeyBoardTop.swift
//  Swift-DZMEditShowKeyBoardTop
//
//  Created by DZM on 15/12/11.
//  Copyright © 2015年 DZM. All rights reserved.
//

/*

// -------------- 监听方法实现 只需拷贝你需要的监听方法 没有实现的监听方法将不会添加到通知中心 ---------
// 键盘开始显示
func keyboardWillShowNotification(notification:NSNotification){

}

// 键盘结束显示
func keyboardDidShowNotification(notification:NSNotification){

}

// 键盘开始隐藏
func keyboardWillHideNotification(notification:NSNotification){

}

// 键盘结束隐藏
func keyboardDidHideNotification(notification:NSNotification){

}

// 键盘开始改变frame
func keyboardWillChangeFrameNotification(notification:NSNotification){

}
*/

/*

// MARK: - 当前能够使用的方法列表 ------------ 介绍



// 获得单利对象
class var editShowKeyBoardTop:DZMEditShowKeyBoardTop




// 添加监听方法 监听方法以实现 只需拷贝你需要的监听方法 没有实现的监听方法将不会添加到通知中心
class func addKeyBoardNotification(object:AnyObject)



/**
传入一个输入框获取输入框的最大Y值

- parameter view: 任何需要弹到键盘之上的控件

- returns: 当前控件在当前界面的最大Y值
*/
class func maxYWithView(view:UIView) ->CGFloat




/**
键盘显示完毕 后 输入框弹到键盘上边 （显示）则在键盘显示监听方法 里面调用即可
maxY可以是任何View的maxY 可以将任何需要弹到键盘之上的View的MaxY
Tablview 跟Collection不用注意 -- scrollview 当contentSize为都0时 传进来会为CGSizeMake(滚动控件的宽度,滚动控件的高度) 这种情况在代码编写的情况会有 就是控件没有达到需要滚动要求 没有设置滚动区域 假如不需要默认设置 你可以自己设置scrollview的contensize在传进来

- parameter notification: 键盘通知的notification
- parameter scrollView:   一个能滚动的view (scrollView,tableView,collectionView)
- parameter maxY:         输入控件的最大Y值
- parameter 但是由于考虑这个MaxY说不定有些需要键盘与输入框中间有一点间距 可以通过单利取出 maxY + 间距值 就可以了
*/
class func keyboardShowWithNotification(notification:NSNotification,scrollView:UIScrollView,maxY:CGFloat)




/**
键盘开始隐藏 的时候 退下去 （隐藏）则在键盘隐藏监听方法 里面调用即可

- parameter notification: 键盘通知的notification
- parameter scrollView:   keyboardShowWithNotification方法中传进去的滚动控件
*/
class func keyboardHideWithNotification(notification:NSNotification,scrollView:UIScrollView)

*/

import UIKit

class DZMEditShowKeyBoardTop: NSObject {
    
    // 属性
    var maxY:CGFloat = 0                    // 当前正在编辑的输入框最大Y值 这个最大Y值就是maxYWithView方法初始化之后得到的MaxY 用于在别的界面使用对象获得使用
    var currentSize:CGSize = CGSizeMake(0, 0)
    var scrollView:UIScrollView?
    var isThree:Bool = false                // 是否是第三方键盘
    var three:Int = 3                       // 第三方键盘需要调用willShow3次
    var threeAnimationDuration:Double = 0.1 // 第三方键盘情况移动动画时间
    var currentKeyboardFrame:CGRect!        // 当前界面frame
    var inputView:UIView!
    
    // 方法名称
    let keyboardWillShowNotification:Selector = "keyboardWillShowNotification:"
    let keyboardDidShowNotification:Selector  = "keyboardDidShowNotification:"
    let keyboardWillHideNotification:Selector = "keyboardWillHideNotification:"
    let keyboardDidHideNotification:Selector  = "keyboardDidHideNotification:"
    let keyboardWillChangeFrameNotification:Selector  = "keyboardWillChangeFrameNotification:"
    
    /// 获取单利对象
    class var editShowKeyBoardTop : DZMEditShowKeyBoardTop {
        struct Static {
            static let instance : DZMEditShowKeyBoardTop = DZMEditShowKeyBoardTop()
        }
        return Static.instance
    }
    
    // MARK: - 为一个对象添加键盘监听通知
    
    /**
    为一个对象添加键盘监听通知
    
    - parameter object: object
    */
    class func addKeyBoardNotification(object:AnyObject){
        
        let notificationCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter();
        
        let editShowKeyBoardTop:DZMEditShowKeyBoardTop = DZMEditShowKeyBoardTop.editShowKeyBoardTop
        
        // 监听键盘开始显示
        if object.respondsToSelector(editShowKeyBoardTop.keyboardWillShowNotification){
            notificationCenter.addObserver(object, selector: editShowKeyBoardTop.keyboardWillShowNotification, name: UIKeyboardWillShowNotification, object: nil)
        }
        
        // 监听键盘结束显示
        if object.respondsToSelector(editShowKeyBoardTop.keyboardDidShowNotification){
            notificationCenter.addObserver(object, selector: editShowKeyBoardTop.keyboardDidShowNotification, name: UIKeyboardDidShowNotification, object: nil)
        }
        
        // 监听键盘开始隐藏
        if object.respondsToSelector(editShowKeyBoardTop.keyboardWillHideNotification){
            notificationCenter.addObserver(object, selector: editShowKeyBoardTop.keyboardWillHideNotification, name: UIKeyboardWillHideNotification, object: nil)
        }
        
        // 监听键盘结束隐藏
        if object.respondsToSelector(editShowKeyBoardTop.keyboardDidHideNotification){
            notificationCenter.addObserver(object, selector: editShowKeyBoardTop.keyboardDidHideNotification, name: UIKeyboardDidHideNotification, object: nil)
        }
        
        // 监听键盘改变frame
        if object.respondsToSelector(editShowKeyBoardTop.keyboardWillChangeFrameNotification){
            
            if NSString(string: UIDevice.currentDevice().systemVersion).floatValue >= 5.0{
                
                notificationCenter.addObserver(object, selector: editShowKeyBoardTop.keyboardWillChangeFrameNotification, name: UIKeyboardWillChangeFrameNotification, object: nil)
            }
        }
    }
    
    // MARK: - 获取位置得出最大Y值
    
    /**
    传入一个输入框获取输入框的最大Y值
    
    - parameter view: 任何需要弹到键盘之上的控件
    
    - returns: 当前控件在当前界面的最大Y值
    */
    class func maxYWithView(view:UIView) ->CGFloat {
        let editShowKeyBoardTop:DZMEditShowKeyBoardTop = DZMEditShowKeyBoardTop.editShowKeyBoardTop
        editShowKeyBoardTop.maxY = DZMEditShowKeyBoardTop.getMaxYWithView(view)
        return editShowKeyBoardTop.maxY
    }
    
    /**
     获取位置得出最大Y值
     
     - parameter view: view
     
     - returns: 最大Y值
     */
    class func getMaxYWithView(view:UIView) ->CGFloat {
        
        let window:UIWindow = ((UIApplication.sharedApplication().delegate?.window)!)!
        let rect = view.convertRect(view.bounds, toView: window)
        let maxY:CGFloat = CGRectGetMaxY(rect)
        return maxY
    }
    
    
    // MARK: - 显示
    
    /**
    键盘显示完毕 后 输入框弹到键盘上边 （显示）则在键盘显示监听方法 里面调用即可
    maxY可以是任何View的maxY 可以将任何需要弹到键盘之上的View的MaxY
    
    - parameter notification: 键盘通知的notification
    - parameter scrollView:   一个能滚动的view (scrollView,tableView,collectionView)
    - parameter maxY:         输入控件的最大Y值
    - parameter 但是由于考虑这个MaxY说不定有些需要键盘与输入框中间有一点间距 可以通过单利取出 maxY + 间距值 就可以了
    return : 键盘高度 关键用于判断第三方键盘 != 0 就是键盘高度
    */
    class func keyboardShowWithNotification(notification:NSNotification,scrollView:UIScrollView,maxY:CGFloat) ->CGFloat {
        
        let editShowKeyBoardTop:DZMEditShowKeyBoardTop = DZMEditShowKeyBoardTop.editShowKeyBoardTop
        
        let keyboardFrame:CGRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue)!
        
        var keyboardAnimationDuration:Double = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue)!
        
        // 检测第三方键盘 假如 键盘高度
        if Int(keyboardFrame.size.height) <= 0 {
            editShowKeyBoardTop.three = 0
            editShowKeyBoardTop.isThree = true
        }
        
        if editShowKeyBoardTop.isThree {
            editShowKeyBoardTop.three += 1
            if editShowKeyBoardTop.three != 3 {
                return 0
            }else{
                editShowKeyBoardTop.isThree = false
            }
            
            keyboardAnimationDuration = editShowKeyBoardTop.threeAnimationDuration
        }
        
        let keyboardY:CGFloat = keyboardFrame.origin.y
        
        if maxY > keyboardY {
            
            if scrollView != editShowKeyBoardTop.scrollView || (scrollView == editShowKeyBoardTop.scrollView && Int(scrollView.contentSize.height) != Int(editShowKeyBoardTop.currentSize.height)) {
                
                if (scrollView == editShowKeyBoardTop.scrollView && Int(scrollView.contentSize.height) != Int(editShowKeyBoardTop.currentSize.height)){
                    
                    if Int(editShowKeyBoardTop.currentSize.height) != 0{
                        
                        editShowKeyBoardTop.scrollView?.contentSize = editShowKeyBoardTop.currentSize
                    }
                }
                
                if editShowKeyBoardTop.currentKeyboardFrame != nil {
                    
                    if Int(editShowKeyBoardTop.currentKeyboardFrame.size.height) != 0 &&  Int(editShowKeyBoardTop.currentKeyboardFrame.size.height) != Int(keyboardFrame.size.height) {
                        
                        if Int(editShowKeyBoardTop.currentSize.height) != 0{
                            
                            editShowKeyBoardTop.scrollView?.contentSize = editShowKeyBoardTop.currentSize
                        }
                    }
                }
                
                editShowKeyBoardTop.setContentSize(scrollView, keyboardFrame: keyboardFrame)
            }
            
            
            UIView.animateWithDuration(keyboardAnimationDuration, animations: { () -> Void in
                
                scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y + (maxY - keyboardY))
            })
            
            editShowKeyBoardTop.currentKeyboardFrame = keyboardFrame
            
        } // end if maxY > keyboardY
        
        return keyboardFrame.size.height
    }
    
    // 设置
    func setContentSize(scrollView:UIScrollView,keyboardFrame:CGRect) {
        
        let height = Int(scrollView.contentSize.height)
        
        if height > 0 {
            
            self.currentSize = scrollView.contentSize
            
        }else{
            
            self.currentSize = CGSizeMake(scrollView.contentSize.width, scrollView.frame.size.height)
        }
        
        self.scrollView = scrollView
        
        scrollView.contentSize = CGSizeMake(self.currentSize.width, self.currentSize.height + keyboardFrame.size.height - (UIScreen.mainScreen().bounds.size.height - DZMEditShowKeyBoardTop.getMaxYWithView(scrollView)))
    }
    
    // MARK: - 隐藏
    
    /**
    键盘开始隐藏 的时候 退下去 （隐藏）则在键盘隐藏监听方法 里面调用即可
    
    - parameter notification: 键盘通知的notification
    - parameter scrollView:   keyboardShowWithNotification方法中传进去的滚动控件
    */
    class func keyboardHideWithNotification(notification:NSNotification) {
        
        let editShowKeyBoardTop:DZMEditShowKeyBoardTop = DZMEditShowKeyBoardTop.editShowKeyBoardTop
        
        let keyboardAnimationDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue)!
        
        UIView.animateWithDuration(keyboardAnimationDuration, animations: { () -> Void in
            
            editShowKeyBoardTop.scrollView?.contentSize = editShowKeyBoardTop.currentSize
            
            }) { (finished) -> Void in
                
                editShowKeyBoardTop.currentSize = CGSizeMake(0, 0)
        }
    }
    
    
    
    // MARK: - 设置一个控件在键盘之上跟着走 建议用于聊天界面中的inputView类似的 以下方法不一定需要放在滚动空间中使用
    
    
    /**
    键盘显示完毕 后 输入框弹到键盘上边 （显示）则在键盘显示监听方法 里面调用即可  类似这种只帮显示 不帮隐藏 位子键盘退下位子自己实现 关键还是帮助适配了第三方键盘
    
    - parameter notification: 键盘通知的notification
    - parameter inputView:   一个inputView
    return : 键盘高度 关键用于判断第三方键盘 != 0 就是键盘高度
    */
    class func keyboardShowInputViewWithNotification(notification:NSNotification,inputView:UIView) -> CGFloat {
        
        let editShowKeyBoardTop:DZMEditShowKeyBoardTop = DZMEditShowKeyBoardTop.editShowKeyBoardTop
        
        let keyboardFrame:CGRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue)!
        
        var keyboardAnimationDuration:Double = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue)!
        
        // 检测第三方键盘 假如 键盘高度
        if Int(keyboardFrame.size.height) <= 0 {
            editShowKeyBoardTop.three = 0
            editShowKeyBoardTop.isThree = true
        }
        
        if editShowKeyBoardTop.isThree {
            editShowKeyBoardTop.three += 1
            if editShowKeyBoardTop.three != 3 {
                return 0
            }else{
                editShowKeyBoardTop.isThree = false
            }
            
            keyboardAnimationDuration = editShowKeyBoardTop.threeAnimationDuration
        }
        
        let maxY = DZMEditShowKeyBoardTop.getMaxYWithView(inputView)
        
        let keyboardY:CGFloat = keyboardFrame.origin.y
        
        
        UIView.animateWithDuration(keyboardAnimationDuration, animations: { () -> Void in
            
            inputView.frame.origin = CGPointMake(0, inputView.frame.origin.y - (maxY - keyboardY))
            
        })
        
        return keyboardFrame.size.height
    }
    
    
}
