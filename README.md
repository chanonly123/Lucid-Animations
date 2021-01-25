
# Lucid Animations swift

### Write clutter free animation code in swift

  

  

## Examples 1: Multi view animations

![alt tag](https://github.com/chanonly123/Lucid-Animations/blob/master/demo1.gif)

```
override func viewDidLoad() {
    super.viewDidLoad()
    stackView.arrangedSubviews.forEach({ $0.transform = .init(translationX: 100, y: 0) })
    lucid.set(duration: 2.0).anim { self.stackView.arrangedSubviews[0].transform = .identity }
    lucid.set(delay: 3.0).set(duration: 0.7).set(bounce: true).serially(count: stackView.arrangedSubviews.count, interval: 0.2) { i in
        self.stackView.arrangedSubviews[i].transform = .identity
    }
    lucid.execute()
}
```

## Example 2: Chaining Animation

![alt tag](https://github.com/chanonly123/Lucid-Animations/blob/master/demo2.gif)

```
@IBAction  func  actionButton() {
    if box.isHidden {
        lucid.flat { self.box.isHidden = false }
        lucid.anim { self.view.layoutIfNeeded() }
        lucid.set(bounce: true).set(duration: 1.0).anim { self.box.alpha = 1; self.box.transform = .identity }
        lucid.execute()
    } else {
        lucid.set(duration: 2.0).anim { self.box.alpha = 0; self.box.transform = .init(translationX: 200, y: 0) }
        lucid.flat { self.box.isHidden = true }
        lucid.anim { self.view.layoutIfNeeded() }
        lucid.execute()
    }
}
```
