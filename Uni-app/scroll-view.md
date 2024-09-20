# scroll-view

> 官方文档：[scroll-view | uni-app官网 (dcloud.net.cn)](https://uniapp.dcloud.net.cn/component/scroll-view.html)

## 参数列表

| 属性名                  | 类型          | 默认值  | 说明                                                         | 平台差异说明                                |
| :---------------------- | :------------ | :------ | :----------------------------------------------------------- | :------------------------------------------ |
| scroll-x                | Boolean       | false   | 允许横向滚动                                                 |                                             |
| scroll-y                | Boolean       | false   | 允许纵向滚动                                                 |                                             |
| upper-threshold         | Number/String | 50      | 距顶部/左边多远时（单位px），触发 scrolltoupper 事件         |                                             |
| lower-threshold         | Number/String | 50      | 距底部/右边多远时（单位px），触发 scrolltolower 事件         |                                             |
| scroll-top              | Number/String |         | 设置竖向滚动条位置                                           |                                             |
| scroll-left             | Number/String |         | 设置横向滚动条位置                                           |                                             |
| scroll-into-view        | String        |         | 值应为某子元素id（id不能以数字开头）。设置哪个方向可滚动，则在哪个方向滚动到该元素 |                                             |
| scroll-with-animation   | Boolean       | false   | 在设置滚动条位置时使用动画过渡                               |                                             |
| enable-back-to-top      | Boolean       | false   | iOS点击顶部状态栏、安卓双击标题栏时，滚动条返回顶部，只支持竖向 | app-nvue，微信小程序                        |
| show-scrollbar          | Boolean       | false   | 控制是否出现滚动条                                           | App-nvue 2.1.5+                             |
| refresher-enabled       | Boolean       | false   | 开启自定义下拉刷新                                           | H5、app-vue 2.5.12+,微信小程序基础库2.10.1+ |
| refresher-threshold     | Number        | 45      | 设置自定义下拉刷新阈值                                       | H5、app-vue 2.5.12+,微信小程序基础库2.10.1+ |
| refresher-default-style | String        | "black" | 设置自定义下拉刷新默认样式，支持设置 black，white，none，none 表示不使用默认样式 | H5、app-vue 2.5.12+,微信小程序基础库2.10.1+ |
| refresher-background    | String        | "#FFF"  | 设置自定义下拉刷新区域背景颜色                               | H5、app-vue 2.5.12+,微信小程序基础库2.10.1+ |
| refresher-triggered     | Boolean       | false   | 设置当前下拉刷新状态，true 表示下拉刷新已经被触发，false 表示下拉刷新未被触发 | H5、app-vue 2.5.12+,微信小程序基础库2.10.1+ |
| enable-flex             | Boolean       | false   | 启用 flexbox 布局。开启后，当前节点声明了 display: flex 就会成为 flex container，并作用于其孩子节点。 | 微信小程序 2.7.3                            |
| scroll-anchoring        | Boolean       | false   | 开启 scroll anchoring 特性，即控制滚动位置不随内容变化而抖动，仅在 iOS 下生效，安卓下可参考 CSS overflow-anchor 属性。 | 微信小程序 2.8.2                            |
| @scrolltoupper          | EventHandle   |         | 滚动到顶部/左边，会触发 scrolltoupper 事件                   |                                             |
| @scrolltolower          | EventHandle   |         | 滚动到底部/右边，会触发 scrolltolower 事件                   |                                             |
| @scroll                 | EventHandle   |         | 滚动时触发，event.detail = {scrollLeft, scrollTop, scrollHeight, scrollWidth, deltaX, deltaY} |                                             |
| @refresherpulling       | EventHandle   |         | 自定义下拉刷新控件被下拉                                     | H5、app-vue 2.5.12+,微信小程序基础库2.10.1+ |
| @refresherrefresh       | EventHandle   |         | 自定义下拉刷新被触发                                         | H5、app-vue 2.5.12+,微信小程序基础库2.10.1+ |
| @refresherrestore       | EventHandle   |         | 自定义下拉刷新被复位                                         | H5、app-vue 2.5.12+,微信小程序基础库2.10.1+ |
| @refresherabort         | EventHandle   |         | 自定义下拉刷新被中止                                         | H5、app-vue 2.5.12+,微信小程序基础库2.10.1+ |

## 示例代码

```vue
        <!-- scroll-y='true'开启y轴滚动，scrolltolower滚动到底部触发 -->
        <scroll-view scroll-y="true" style="height: 50vh;" @scrolltolower="scrolltolower">
            <u-row align="top">
                <u-col span="0.3"></u-col>
                <u-col span="11.4">
                    <view v-for="(item, index) in information.informationList[tabs.currentTab]" :key="index"
                          v-show="information.informationList[tabs.currentTab]"
                          style="border: 2rpx solid #e6edf2;border-radius: 17rpx; margin: 17rpx 0;box-shadow: 0px 6rpx 8rpx 0px rgba(24, 144, 255, 0.06);">
                        <u-row @click.native="getDetail(item)" customStyle="height: 170rpx">
                            <u-col span="8" offset="0.3">
                                <u--text :text="item.title" :lines="2" lineHeight="26"
                                         size="27rpx"></u--text>
                                <view style="height: 12rpx"></view>
                                <u-row>
                                    <u-col span="4">
                                        <u--text :text="'阅读' + item.hit" size="24rpx" type="info"></u--text>
                                    </u-col>
                                    <u-col span="7" offset="0.5">
                                        <u--text :text="item.time" size="24rpx" type="info"></u--text>
                                    </u-col>
                                </u-row>
                            </u-col>
                            <u-col span="3" offset="0.5">
                                <image :src="item.img && Array.isArray(item.img) ? item.img[0] : item.img"
                                       style="width: 200rpx;height: 150rpx; border-radius: 10rpx;"></image>
                            </u-col>
                        </u-row>
                    </view>
                </u-col>
            </u-row>
        </scroll-view>
```

> ![image-20240918153115219](img/scroll-view/image-20240918153115219.png)
