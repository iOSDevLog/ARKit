# ARKit 教学：如何搭配SceneKit来建立一个简单的ARKit Demo
---

增强现实(Argument Reality)来啰！记得宝可梦(Pokemon Go)吗？它当然也是增强现实的代表之一！Apple终于在iOS11将增强现实带进来，也因为iOS11，未来将会有数不清的iPhones和iPads就会搭载AR功能，这将会让[ARKit](https://developer.apple.com/arkit/)成为世界最大的平台，是的，如果你对建置增强现实的Apps有兴趣，让你就来对地方了。

## 目标

本教学主要会开发一个ARkit Demo App，并应用SceneKit来协助你熟悉基础的ARKit。

是时候让你开始沉浸在本篇教学内，并让你了解如何一步一步建构出ARKit App，且透过你手上的装置与AR世界互动。

本篇教学的想法主要是学习AR与利用API来建置一个APP，藉由教学的步骤，你将会一步步了解ARKit在实体装置上是如何与神奇的3D物件来互动的。

在开始前，请了解本篇教学仅是以基础功能应用为主。

## 你需要准备的

进入本篇教学前，建议你已有对iOS的基础开发的能力，这属于中阶程度的教学，并且，我们将需要Xcode9以上的版本。

为了测试你的ARKit App，你得需要一个可兼容Apple的ARkit的装置，建议有Apple A9处理器以上等级的装置。

现在请确认你已具备上述需求，并准备开始进行，以下是我将会带你走过：

*   建立一个新的ARKit apps项目
*   设定ARKit SceneKit View
*   将ARSCNView与View Controller结合
*   连接IBOutlet
*   设定ARSCNView Session
*   允许相机使用权限
*   将3D物件加到ARSCNView
*   加入手势判断功能到ARSCNView
*   从ARSCNView移除物件
*   加入多样物件到ARSCNView

## 建立一个新的ARKit apps项目

再来，打开Xcode，在Xcode的菜单中，选择File > New > Project… ，然后选择Single View App并按下`next`，其实Xcode也有内键ARKit的范例App，但你仍可以使用Single View App来开发AR app。

![arkit-1](http://upload-images.jianshu.io/upload_images/910914-c7eb6a0ef5508781.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

你可以自行命名你想要的项目名称，我是命名为**ARKitDemo**，再按下next来完成新的项目。

## 设定ARKit SceneKit View

现在请打开Storyboard，请在右下角的Object Library找到ARKit SceneKit View，将它拖拉至你的View Controller。

![image](http://upload-images.jianshu.io/upload_images/910914-9540b1765d9afbfd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后将你的ARKit SceneKit View的尺寸拉满整个View Controller，它应该会呈现如下方：

![image](http://upload-images.jianshu.io/upload_images/910914-23dcb5cbd87e96a0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这样的话，ARKit SceneKit View就是我们要呈现增强现实的SceneKit内容的位置。

## 连接IBOutlet

我们目前仍在Main.storyboard位置，请往介面右上方找到`toolbar`，并开启`Assistant Editor`，现在将`ARKit`连接到ViewController.swift档位置：

```swift
import  ARKit
```

接着请按住control并在ARKit ScenKit的View上拖到至`ViewController.swift`，当连接到时，请指定为IBOutlet，并命名为`sceneView`，对了，请放心地将`didReceiveMemoryWarning()`这个方法删除，我们不会在本篇教学使用到它。

![Creating an outlet variable for the scene view](http://upload-images.jianshu.io/upload_images/910914-a1b1a12bb024111e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 设定ARKit SceneKit View

若想要我们的App在一开始执行时就能透过相机看到真实世界，并能侦测我们的周遭环境，这其实是相当惊人的科技！如今Apple已经帮开发者建立一套增强现实的功能，我们并不需要再多花时间从无到有的重新设计，所以，谢谢Apple！让我们能拥抱ARKit。

好的！现在是时候来设定ARkit SceneKit View了，请在ViewController的类别下插入下列代码：

```swift
override  func  viewWillAppear(_  animated:  Bool)  {
    super.viewWillAppear(animated)

    let  configuration  =  ARWorldTrackingConfiguration()
    sceneView.session.run(configuration)
}
```

并在`viewWillAppear(_:)`方法内，我们将初始化AR ?configuration，它称为`ARWorldTrackingConfiguration`，这是一个可以执行world tracking的功能设定，等等！你一定会问什么是world tracking？来看一下Apple的官方文件说明：

> “World tracking可提供装置上六个自由度轨迹，来找到场景所需的特征点，world tracking也会启用performing hit-tests against the frame. 当这个单元暂停后，Tracking将不会再执行。”
>
> “World tracking provides 6 degrees of freedom tracking of the device. By finding feature points in the scene, world tracking enables performing hit-tests against the frame. 
> Tracking can no longer be resumed once the session is paused.”
>
> -Apple官方文档

所以简单说明world tracking可以追踪装置的方位与位置，它也可以经由装置的相机来侦测真实世界的地平面。

最后一段代码，AR单元( Session)主要是管理动作追踪与相机影像处理内容。我们需要执行这个`configuration`

接下来，我们来加入另一个方法到`ViewController`内：

```swift
override  func  viewWillDisappear(_  animated:  Bool)  {
    super.viewWillDisappear(animated)

    sceneView.session.pause()
}
```

在`viewWillDisappear(_:)`方法中，我们主要做的是当view在关闭时，设定AR单元就会同时停止追踪动作与处理图像内容。

##允许相机使用权限

在我们要执行我们的App之前，我们需要告知我们使用者，我们得使用相机来进行增强现实的应用，这是一个从iOS10就开始的必要询问告知动作，也因此，请打开info.plist 。然后在空白区域点选右键，并选择*Add row*，在key下选用Privacy –   *Camera Usage Description*，然后在Value下写下*For Augmented Reality*。

![image](http://upload-images.jianshu.io/upload_images/910914-c8c6ef97e2435b4d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

请确认此时你已经做好刚刚所教的一切。

请拿起你的装置，并连线到你的Mac，来第一次建立与执行在Xcode的项目，此时这个App将会询问你能否允许有打开相机的权限。请点按OK。若选择Don't allow，代表App不能使用相机来做想要执行的事情。

![using camera](http://upload-images.jianshu.io/upload_images/910914-8b18f8c6179ca3ef.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

现在你应该能够看到你相机画面了。

我们也算是设定好我们的sceneView单元，并能执行world tracking，是时候进入令人兴奋的阶段了！增强现实！

##将3D物件加到ARSCNView

话不多说，直接进入增强现实，我们将要一个立方体(box)，那我们先将下列代码加到你的`ViewController`类别。

```swift
func  addBox()  {
    let  box  =  SCNBox(width:  0.1,  height:  0.1,  length:  0.1,  chamferRadius:  0)
    let  boxNode  =  SCNNode()
    boxNode.geometry  =  box
    boxNode.position  =  SCNVector3(0,  0,  -0.2)

    let  scene  =  SCNScene()
    scene.rootNode.addChildNode(boxNode)
    sceneView.scene  =  scene
}
```

现在来解释一下我们做了些什么。

我们先要来建立一个立方体`box`的外型，1 Float = 1米。

接下来，我们建立一个点位`boxNode`物件，这个点位可代表位置与一个物件在3D空间的坐标，但对它自己而言，他本身不会有可以看到的内容，需要协助它添加资讯。

所以我们需要在这个点位来建立一个形状，并给予一些可视化的内容。先将立方体`box`的参数设为点位`boxNode`的几何资讯，我们再给我们的点位一个位置，然而这个位置和相机有关系，以正x轴而言，是右边；负x轴是左边，正Y轴是上方，负Y轴是下方，而正Z轴是往后，负Z轴是往前。

接着，我们要来建立一个场景，这是一个应用SceneKit的场景功能来显示在视图上，过来加入我们的`boxNode`做为场景的初始根点位，然而初始根点位在一个场景中，是SceneKit用来定义与真实世界的坐标系统的方式。

正常来说，我们的场景现在会有了一个立方体了，这个立方体会位在相机画面的正中间，和相机的距离会有0.2米。

最后，让我们的sceneView来显示我们刚建立的场景。

现在请在`viewDidLoad()`加入`addBox()`的方法：

```swift
override  func  viewDidLoad()  {
    super.viewDidLoad()

    addBox()
}
```

建立并执行这个App，你应该可以看见一个飘浮在空中的立方体啰！

![image](http://upload-images.jianshu.io/upload_images/910914-558251e9845ce831.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

你现在也可以重新简化`addBox()`的方法：

```swift
func  addBox()  {
    let  box  =  SCNBox(width:  0.05,  height:  0.05,  length:  0.05,  chamferRadius:  0)
    let  boxNode  =  SCNNode()
    boxNode.geometry  =  box
    boxNode.position  =  SCNVector3(0,  0,  -0.2)
    sceneView.scene.rootNode.addChildNode(boxNode)
}
```

这会更容易了解在做些什么事了吧。

好的！要继续加入手势了！

##加入手势辨识方法到ARSCNView

在`addBox()`的方法下，请加入下列代码：

```swift
func  addTapGestureToSceneView()  {
    let  tapGestureRecognizer  =  UITapGestureRecognizer(target:  self,  action:  #selector(ViewController.didTap(withGestureRecognizer:)))
    sceneView.addGestureRecognizer(tapGestureRecognizer)
}
```

在这里，我们先初始化点击手势辨识方法物件，并将`target`设为`ViewController`，也就是`self`，在`action`内设为`didTap(withGestureRecognizer:)`，然后我们再将点击手势辨识这个物件也加入在scenView内。

是时候来做些点击手势辨识方法物件内的调用方法

#从ARSCNView移除物件

在`ViewController.swift`加入下列代码：

```swift
@objc func  didTap(withGestureRecognizer recognizer:  UIGestureRecognizer)  {
    let  tapLocation  =  recognizer.location(in:  sceneView)
    let  hitTestResults  =  sceneView.hitTest(tapLocation)
    guard let  node  =  hitTestResults.first?.node  else  {  return  }
    node.removeFromParentNode()
}
```

在这里，我们建立了`didTap(withGestureRecognizer:)`的方法，目的是我们要获得使用者在sceneView的点击位置，并可看得到我们触击的node。

然后，我们将从`hitTestResults`中移除掉第一个点位，如果`hitTestResults`内没得到任何一个点位，我们将会移除当初第一个点击 parent node。

在我们测试物件移除时，请更新`viewDidLoad()`的方法，并加入一个调用`addTapGestureToSceneView()`的方法：

```swift
override  func  viewDidLoad()  {
    super.viewDidLoad()

    addBox()
    addTapGestureToSceneView()
}
```

现在如果你若能建置与执行你的项目，你应该可以点击box node并能从scene view移除它。

不过我们感觉回到了起点。

没关系！那我们来加多点物件。

## 加入多样物件到ARSCNView

现在我们的立方体感觉有点孤独，我们也来多做一点立方体吧，我们将在一些特征点上加入物件。

所以什么是特征点呢？

根据Apple官方说明，对特征点的定义：

> 此点由ARKit自动从一个连续的表面中自动辨识，但不会有另一相对的依靠点。

它其实是依真实世界的实物表面上侦测特征点，所以，我们回到如何实现增加立方体呢，在我们开始前，在ViewController类别的代码最下方建立一个extension。

```swift
extension  float4x4  {
    var  translation: float3  {
        let  translation  =  self.columns.3
        return  float3(translation.x,  translation.y,  translation.z)
    }
}
```

这个exetension建立了一个`float3`的矩阵，它可同时加入x, y和z三个参数。

因此，我们下一步要修改`addBox()`：

```swift
func  addBox(x:  Float  =  0,  y:  Float  =  0,  z:  Float  =  -0.2)  {
    let  box  =  SCNBox(width:  0.1,  height:  0.1,  length:  0.1,  chamferRadius:  0)
    let  boxNode  =  SCNNode()
    boxNode.geometry  =  box
    boxNode.position  =  SCNVector3(x,  y,  z)
    sceneView.scene.rootNode.addChildNode(boxNode)
}
```

基本上，我们加入了参数来初始化`addBox()`的方法，同时也给它一个初始值，这代表我们可以不用在`viewDidLoad()`调用`addBox()`的方法时，就得写入特定x, y和z坐标值。

好的！

现在我们需要修改`didTap(withGestureRecognizer:)`的方法，我们想要当真实世界的某一点被侦测到时，我们就能加入一个物件。

所以回到我们的`guard let`的代码描述，在`else`之后，并在`return`之前，请加入下列代码：

```swift
let  hitTestResultsWithFeaturePoints  =  sceneView.hitTest(tapLocation,  types: .featurePoint)

if  let  hitTestResultWithFeaturePoints  =  hitTestResultsWithFeaturePoints.first  {
    let  translation  =  hitTestResultWithFeaturePoints.worldTransform.translation
    addBox(x:  translation.x,  y:  translation.y,  z:  translation.z)
}
```

来解释我们想要达成的方式。

首先，我们先要有一个hit test，很像是我们第一次测试，除了这个，我们清楚定义`.featurePoint`属于`types`参数。`types`参数要求hit test经由AR单元的相机图像来搜寻真实世界的实体物或是表面。它内含许多类型，但本教学目前只针对特征点。

经由特征点的hit test后，我们可以安全地移除第一次hit test的结果，这观念很重要，因为不会一直都有特征点，ARKit并不会一会侦测真实世界的实体物与表面。

如果第一次hit test能成功移除，然后我们就将转换矩阵类型`matrix_float4x4`到`float3`，因为我们之前已增加了一个extension来完成此功能，有兴趣的话，我们也可以自行修正x, y和z实际世界坐标。

然后，我们在一特征点上输入x, y和z来加入一个立方体。

你的`didTap(withGestureRecognizer:)`方法应如下所示：

```swift
@objc func  didTap(withGestureRecognizer recognizer:  UIGestureRecognizer)  {
    let  tapLocation  =  recognizer.location(in:  sceneView)
    let  hitTestResults  =  sceneView.hitTest(tapLocation)

    guard let  node  =  hitTestResults.first?.node  else  {
        let  hitTestResultsWithFeaturePoints  =  sceneView.hitTest(tapLocation,  types:  .featurePoint)
        if  let  hitTestResultWithFeaturePoints  =  hitTestResultsWithFeaturePoints.first  {
            let  translation  =  hitTestResultWithFeaturePoints.worldTransform.translation
            addBox(x:  translation.x,  y:  translation.y,  z:  translation.z)
        }
        return
    }

    node.removeFromParentNode()
}
```

## 测试最终版App

现在是时候按Run 键执行项目以测试最终版的App！

![image](http://upload-images.jianshu.io/upload_images/910914-613ebb5d970ff09e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 总结

恭喜你，和我们走了这么久完成本篇教学，ARKit还有还有许多功能需要我们继续挑战，我们只是学了一些表面功夫。

我希望你享受本篇ARKit的介绍，我也期待你会建构出属于你的ARKit App。

关于完整的范例项目，你可以在[GitHub](https://github.com/appcoda/SimpleARKitDemo)找到。

如果你还想学习更多有关ARKit的开发，请分享此教学给你朋友并让我知道。

**原文**：[Building a Simple ARKit Demo with SceneKit in Swift 4 and Xcode 9](https://www.appcoda.com/arkit-introduction-scenekit/)
