//
//  DHBaseNavigationController.swift
//  Prestapronto
//
//  Created by dh on 2023/3/7.
//

import UIKit

class DHBaseNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    var isHideSeparator:Bool? {
        didSet {
            if let isHidden = isHideSeparator {
                self.separatorLine.isHidden = isHidden
            }
        }
    }
    
    lazy var separatorLine:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.navigationBar.bounds.size.height - 0.5, width: self.navigationBar.bounds.size.width, height: 0.5))
        view.backgroundColor = UIColor("#e8e8e8")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.addSubview(separatorLine)
        setSkin()
    }
    
    func setSkin() {
        let dict = [NSAttributedString.Key.font:dhBoldFont17, NSAttributedString.Key.foregroundColor:dhColor3]
        self.navigationBar.titleTextAttributes = dict
        self.navigationBar.barTintColor = .white
        self.navigationBar.tintColor = dhColor3
        
        
        self.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            // 隐藏导航栏下黑线
            appearance.shadowColor = .clear;
            appearance.titleTextAttributes = dict
            //常规页面
            self.navigationBar.standardAppearance = appearance
            //呆scroll滑动页面
            self.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let topVc = self.topViewController
        if let vc = topVc {
            return vc.preferredStatusBarStyle
        }else{
            return UIStatusBarStyle.default
        }
    }

    // MARK: - rotation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
 
    override var shouldAutorotate: Bool {
        return false
    }
 
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        viewControllers.last!.hidesBottomBarWhenPushed = true
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 如果不是根控制器，隐藏TabBar
        if (self.viewControllers.count > 0) {
            // 注意这里是push进来的ViewContoller隐藏TabBar
            viewController.hidesBottomBarWhenPushed = true
            if (viewController.navigationItem.leftBarButtonItems?.count ?? 0 > 0 || viewController.navigationItem.leftBarButtonItem != nil) {
            }else{
                if viewController.responds(to: #selector(customLeftBarItems)) {
                    let customLeftBarItems = viewController.customLeftBarItems()
                    if customLeftBarItems == nil || customLeftBarItems?.count ?? 0 == 0 {
                        viewController.navigationItem.leftBarButtonItems = nil
                        viewController.navigationItem.leftBarButtonItem = nil
                        viewController.navigationItem.title = ""
                        viewController.navigationItem.hidesBackButton = true
                    }else{
                        viewController.navigationItem.leftBarButtonItems = viewController.customLeftBarItems()
                    }
                }
                else if viewController.responds(to: Selector("zwt_setLeftBackBarItem")) { 
                    viewController.zwt_setLeftBackBarItem()
                }
            }
        }
        
        //处理左滑手势
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        super.pushViewController(viewController, animated: animated)
    }
 
    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
 
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        

        if (self.responds(to: #selector(getter: interactivePopGestureRecognizer))) {
            //tab上面的vc禁用右滑返回
            if (navigationController.viewControllers.count > 0 && viewController == navigationController.viewControllers[0]) {
                self.interactivePopGestureRecognizer?.isEnabled = false
            }else {
                if (viewController.disablePopGesture) {
                    self.interactivePopGestureRecognizer?.isEnabled = false
                }else{
                    self.interactivePopGestureRecognizer?.isEnabled = true
                }
            }
        }
        
        if (isIPhoneX) {
            // 修改tabBra的frame
            var frame = self.tabBarController?.tabBar.frame
//            frame?.origin.y = UIScreen.main.bounds.size.height - (frame?.size.height ?? 0)
//            self.tabBarController?.tabBar.frame = frame ?? <#default value#>
        }
    }

    // MARK: - gestureRecognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if (self.navigationController?.interactivePopGestureRecognizer == gestureRecognizer) {
            if (otherGestureRecognizer.view is UIScrollView) {
                let scrollView = otherGestureRecognizer.view as! UIScrollView
                if ((scrollView.contentSize.width > CGRectGetWidth(self.view.bounds) && scrollView.contentOffset.x == 0)) {
                    return true
                }
            }
        }
        
        return false
    }
 
   

}
