//
//  TutorialPageViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 21.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController , UIPageViewControllerDelegate, UIPageViewControllerDataSource{

    let welcomeCtrl = WelcomeViewController();
    let loginCtrl = LoginViewController();
    let avatarCtrl = AvatarCollectionViewController();
    let colorCtrl = SelectColorViewController();
    var index = 0;
    var lastIndex = 0;
    var pageCount = 4;
    
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
        controllers = [welcomeCtrl,loginCtrl,avatarCtrl,colorCtrl];
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.setTutorialPageViewController, object: nil, queue: nil, using: setCurrentViewController)
    }
    
    func setCurrentViewController(notification:Notification) {
        let indexOfNexPage = notification.userInfo?["pageIndex"] as! Int
        self.setViewControllers([controllers[indexOfNexPage]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return nil
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
