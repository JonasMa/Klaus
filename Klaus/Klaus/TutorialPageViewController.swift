//
//  TutorialPageViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 21.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController , UIPageViewControllerDelegate, UIPageViewControllerDataSource{

    let loginCtrl = LoginViewController();
    let avatarCtrl = AvatarViewController();
    var index = 0;
    var lastIndex = 0;
    var pageCount = 2;
    
    var isAnimating = false;
    
    var controllers: Array<UIViewController>!;
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.setViewControllers([controllers[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;
        self.dataSource = self;
        
        
        self.preferredContentSize = CGSize(width: 200, height: 200);
        controllers = [loginCtrl,avatarCtrl];
        
    
        
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
        if(index >= (self.controllers.count)-1 || isAnimating){
            return nil
        }
        lastIndex = index;
        index += 1;
        return self.controllers[index];
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        return nil;
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count;
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0;
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if(index == 0){
            return LoginViewController();
        }else if(index == 1){
            return AvatarViewController();
        }else{
            return nil;
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        isAnimating = true;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(!completed){
            index = lastIndex;
        }
        isAnimating = false;
        
    }
}
