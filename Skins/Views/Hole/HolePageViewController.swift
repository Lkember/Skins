//
//  HolePageViewController.swift
//  Skins
//
//  Created by Logan Kember on 2020-03-06.
//  Copyright © 2020 Logan Kember. All rights reserved.
//

import UIKit

class HolePageViewController: UIPageViewController , UIPageViewControllerDataSource, UIPageViewControllerDelegate, PageControlCallback {
    
    var holeScoreHelperVC: HoleScoreHelperViewController?
    var game: GolfGame = GolfGame.init()
    var currIndex: Int = 0
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        
        decoratePageControl()
        
        if let firstHole = game.holes.first {
            let holeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HoleScoreViewController") as! HoleScoreViewController
            holeVC.updateHole(hole: firstHole)
            holeVC.titlePassback = holeScoreHelperVC
            
            setViewControllers([holeVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func decoratePageControl() {
        let pc = UIPageControl.appearance(whenContainedInInstancesOf: [HolePageViewController.self])
        pc.currentPageIndicatorTintColor = .green
        pc.pageIndicatorTintColor = .gray
    }
    
    fileprivate func createHoleViewController() -> UIViewController {
        let holeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HoleScoreViewController") as! HoleScoreViewController
        
        holeVC.updateHole(hole: game.holes.first!)
        holeVC.titlePassback = holeScoreHelperVC

        return holeVC
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - TitleUpdateCallback
    
    // MARK: - PageControlCallback
    func PageCountChanged() {
        if let controllers = self.viewControllers {
            if controllers.count > 0 {
                self.setViewControllers(controllers, direction: .forward, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - PageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? HoleScoreViewController {
            if let index = game.holes.firstIndex(of: vc.currHole) {
                var index = index
                
                let holeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HoleScoreViewController") as! HoleScoreViewController
                if (index-1 < 0) {
                    index = game.holes.count - 1
                }
                else {
                    index = index - 1
                }
                
                holeVC.updateHole(hole: game.holes[index])
                holeVC.titlePassback = holeScoreHelperVC
                return holeVC
            }
        }
        
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? HoleScoreViewController {
            if let index = game.holes.firstIndex(of: vc.currHole) {
                let holeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HoleScoreViewController") as! HoleScoreViewController
                holeVC.updateHole(hole: game.holes[(index+1) % game.holes.count])
                holeVC.titlePassback = holeScoreHelperVC
                return holeVC
            }
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return game.holes.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currVC = viewControllers?.first as? HoleScoreViewController {
            return game.holes.firstIndex(of: currVC.currHole) ?? 0
        }
        
        return 0
    }
}
