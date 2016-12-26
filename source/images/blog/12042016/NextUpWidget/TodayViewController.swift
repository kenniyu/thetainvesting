//
//  TodayViewController.swift
//  NextUp
//
//  Created by Daniel Shusta on 10/5/16.
//  Copyright © 2016 Coursera. All rights reserved.
//

import CourseraFoundation
import CourseraUIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    private let ViewDataUserDefaultsCacheKey = "ViewDataUserDefaultsCacheKey"
    private let sharedUserDefaults = NSUserDefaults(suiteName: "group.org.coursera.coursera")

    var viewModel: NextUpWidgetViewModel!
    var eventHandler: NextUpWidgetEventHandler!
    
    var nextUpCourseData = [FormattedNextUpCourseData]()
    var nextUpNib: UINib?

    @IBOutlet weak var stackView: UIStackView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.

        let presenter = NextUpWidgetPresenter()
        viewModel = presenter
        eventHandler = presenter

        nextUpNib = UINib(nibName: "NextUpView", bundle: nil)

        bindViewModel()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if stackView.arrangedSubviews.isEmpty {
            if let viewDataCache = sharedUserDefaults?.arrayForKey(ViewDataUserDefaultsCacheKey) as? [[String: String]] {
                nextUpCourseData = viewDataCache.flatMap { FormattedNextUpCourseData.fromPlistDict($0) }
            }
            refreshViews()
        }

        eventHandler.didLoad()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        let viewDataCache = nextUpCourseData.map { $0.toPlistDict() }
        sharedUserDefaults?.setObject(viewDataCache, forKey: ViewDataUserDefaultsCacheKey)
    }

    func bindViewModel() {
        viewModel.courses.bind { [weak self] (nextUpCourseData) in
            guard let `self` = self else { return }
            
            guard !nextUpCourseData.isEmpty else { return }
            
            self.nextUpCourseData = nextUpCourseData
            self.refreshViews()
        }
    }

    func refreshViews() {
        if extensionContext?.widgetActiveDisplayMode == .Compact, let firstNextCourseData = nextUpCourseData.first {
            if let firstView = stackView.arrangedSubviews.first as? NextUpView {
                firstView.configure(firstNextCourseData)
            } else {
                guard let nibView = nextUpNib?.instantiateWithOwner(nil, options: nil).first as? NextUpView else {
                    return
                }
                nibView.configure(firstNextCourseData)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemTapped))
                nibView.addGestureRecognizer(tapGesture)
                nibView.nextStepButton.addTarget(self, action: #selector(itemTapped), forControlEvents: .TouchUpInside)
                stackView.addArrangedSubview(nibView)
            }
        }
    }

    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        eventHandler.updateData { (result) in
            switch result {
            case .Value(_):
                completionHandler(NCUpdateResult.NewData)
            case .Error(let error):
                guard let errorKind = error.kind() else {
                    completionHandler(NCUpdateResult.Failed)
                    return
                }
                
                switch errorKind {
                case .NoDataAvailable:
                    completionHandler(NCUpdateResult.NoData)
                default:
                    completionHandler(NCUpdateResult.Failed)
                }
            }
        }
    }

    func itemTapped() {
        guard let firstNextCourseData = nextUpCourseData.first else {
            print("====> Item was tapped but there's no content. What even was tapped?")
            return
        }

        let urlPath = "coursera-mobile://app/home/"
        let URL = NSURL(string: urlPath)!
        extensionContext?.openURL(URL, completionHandler: nil)
    }

}
