# SwiftMVCR (Model, View, Controller, Router)

SwiftMVCR is an example iOS App written in Swift using the MVCR architecture.  (Model, View, Controller, Router)

[![Language](https://img.shields.io/badge/language-Swift%204.2-orange.svg)](https://swift.org)

## Description

MVCR means Model, View, Controller, Router. 
You can easy to know transitions of app.

### View (including UIViewController)
View must implement Viewable. Viewable has Default Extension.  

```swift

protocol Viewable: AnyObject {
    func push(_ vc: UIViewController, animated: Bool)
    func present(_ vc: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
    func dismiss(animated: Bool, completion: @escaping (() -> Void))
}

extension Viewable where Self: UIViewController {

    func push(_ vc: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }

    func present(_ vc: UIViewController, animated: Bool) {
        self.present(vc, animated: animated, completion: nil)
    }

    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }

    func dismiss(animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }

    func dismiss(animated: Bool, completion: @escaping (() -> Void)) {
        self.dismiss(animated: animated, completion: completion)
    }
}


```

Example

```swift

extension ViewController: Viewable {}

```

### Controller (including UIViewController)
Controller must implement Controllerable.


```swift
protocol Controllerable {
    associatedtype R: Routerable
    var router: R! { get }
}
```

Example

```swift

final class ViewController: UIViewController, Controllerable {
    
    ...
    
    static func configure(entryModel: EntryModel) -> ViewController {
        let controller = ViewController()
        controller.router = RouterOutput(controller)
        controller.entryModel = entryModel
        return controller
    }
    private(set) var router: RouterOutput!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    ...
}
```

**UIViewController has roles that View and Controller. But,  its ok.**


### Router
Router must implement Routerable.


```swift
protocol Routerable {
    var view: Viewable! { get }

    func dismiss(animated: Bool, completion: @escaping (() -> Void))
    func pop(animated: Bool)
}

extension Routerable {
    func dismiss(animated: Bool, completion: @escaping (() -> Void)) {
        view.dismiss(animated: animated, completion: {})
    }

    func pop(animated: Bool) {
        view.pop(animated: animated)
    }
}
```

Example

```swift


struct EntryModel {}

final class RouterInput {
    func push(from: Viewable, entryModel: EntryModel) {
        let controller = ViewController.configure(entryModel: entryModel)
        from.push(controller, animated: true)
    }

    func present(from: Viewable, entryModel: EntryModel) {
        let controller = ViewController.configure(entryModel: entryModel)
        from.present(controller, animated: true)
    }
}

final class RouterOutput: Routerable {

    weak private(set) var view: Viewable!

    init(_ view: Viewable) {
        self.view = view
    }

    func transitionToOther(entryModel: EntryModel) {
        OtherRouterInput().push(from: view, entryModel: entryModel)
    }
}
```




## Requirements

- iOS 10.0+
- Xcode 10.0+
- Swift 4.2+

## Installation

```
git clone git@github.com:yokurin/SwiftMVCR.git
```

## Author

Tsubasa Hayashi, yoku.rin.99@gmail.com

## License

SwiftMVCR is available under the MIT license. See the LICENSE file for more info.
