# $set和$delete

## $set

### 使用场景

> Vue的`$set`方法是Vue实例上的一个实用方法，它的作用是向响应式对象中添加一个属性，并确保这个新属性也是响应式的，能够触发视图更新。这是Vue提供的用于解决Vue不能检测属性添加的限制的方法

**`Vue.$set`用途**：

- 添加响应式属性： 需要在响应式对象中添加一个新的属性，并且希望这个属性能够触发视图更新时
- 更新数组： 想要在数组中添加一个元素，或者修改数组的某个索引位置的值，并且希望这个操作能够触发视图更新

**基本使用**：

- 对象添加属性： 在Vue实例创建后，需要动态地向一个对象添加新的属性，并且这个对象是响应式的，直接添加属性可能不会触发视图更新。这时使用`$set`可以确保新属性是响应式的

  - ```js
    this.$set(this.someObject, 'newProperty', 'value');
    ```

- 数组更新： 当你需要更新数组中的元素，需要直接设置数组的某个索引位置的值时，使用`$set`可以确保这个更新是响应式的

  - ```js
    this.$set(this.someArray, index, newValue);
    ```

**注意事项**：

- `Vue.$set`是Vue 2.x版本中的一个特性。在Vue 3.x中，由于Vue 3使用了Proxy代理，可以自动检测对象属性的添加和删除，因此不再需要`$set`来添加响应式属性
- `Vue.$set`只能用于添加或修改响应式对象的属性，对于非响应式对象，不会有任何效果
- `Vue.$set`不能用于替换整个对象或数组。需要替换整个响应式对象或数组，应该直接赋值

> 需要确保操作的是响应式对象。如果在一个非响应式的对象上使用`$set`，那么这个对象不会变成响应式的，也不会触发视图更新

### 示例代码

```vue
        <!-- 资讯类消息展示 -->
        <view v-for="(item, index) in information.informationList[tabs.currentTab]" :key="index" 
		v-show="information.informationList[tabs.currentTab]"
		>
          <u-row customStyle="margin-top: 20px;" @click.native="getDetail(item)">
            <u-col span="0.7">
              <view style="background-color: #ffffff;"></view>
            </u-col>
            <!-- 文字内容 -->
            <u-col span="7.5">
              <u--text :text="item.title" lineHeight="26" size="30rpx"></u--text>
              <u-row customStyle="margin-top: 7px;">
                <u-col span="3">
                  <u--text :text="'阅读' + item.hit" size="24rpx" type="info"></u--text>
                </u-col>
                <u-col span="7" offset="0.5">
                  <u--text :text="item.time" size="24rpx" type="info"></u--text>
                </u-col>
              </u-row>
            </u-col>
            <u-col span="3" offset="0.3">
              <image :src="item.img && Array.isArray(item.img)? item.img[0]: item.img" style="width: 100px;height: 70px; border-radius: 5px;"></image>
            </u-col>
          </u-row>
        </view>


	async getInformation(index) {
		let res = await getInformationByIndex(index, this.pageObj.pageParam)
		// 如果为空，则进行初始化
		if (!this.information.informationList[index]) {
			this.information.informationList[index] = []
		}
		let currentResult = []
		for(let i of res.rows) {
			currentResult.push({
				'id': i.messageId,
				'title': i.title,
				'img': config.baseUrl + i.img,
				'time': i.createTime,
				'hit': i.hit,
				'url': i.url
			})
		}
		// 添加信息
		this.$set(this.information.informationList, index, currentResult);
		// this.information.informationList[index] = [...this.information.informationList[index], ...currentResult]
		console.log(this.information.informationList, res)
	},
```

## $delete

**`Vue.$delete`用途**：

- 删除响应式属性： 确保删除操作是响应式的，能够触发视图更新

示例：

```js
this.$delete(this.myObject, 'propertyName');
```

**注意事项**：

- `Vue.$delete`是Vue 2.x版本中的一个特性。在Vue 3.x中，由于Vue 3使用了Proxy代理，可以自动检测对象属性的添加和删除，因此不再需要`$delete`来添加响应式属性
- `Vue.$delete`只能用于添加或修改响应式对象的属性，对于非响应式对象，不会有任何效果

`$delete` 方法的基本语法如下：

```js
Vue.$delete(target, key)
```

- `target`：要删除属性的对象
- `key`：要删除的属性的键名

在 Vue 3.x 中，可以这样删除响应式对象的属性：

```js
const myObject = reactive({ propertyName: 'value' });

// 删除属性
delete myObject.propertyName;
```

> 不需要特殊的 `$delete` 方法，因为 Vue 3 的响应式系统会自动处理

示例代码：

```vue
    submit(ref) {
      this.getEditRules()
      this.$refs.form.validate().then(res => {
        addAuthentication(this.user).then(async (response) => {
          this.$modal.msgSuccess("提交认证成功")
          await this.$login.sleep()
          this.$tab.navigateBack()
        })
      })
    },


    getEditRules() 
      if (this.user.userType == 104) {
        this.$delete(this.rules, 'governmentPosition');
        this.$delete(this.rules, 'governmentName');
        this.$set(this.rules, 'companyType', {
          rules: [{
            required: true,
            errorMessage: '公司类型不能为空'
          }]
        });
        this.$set(this.rules, 'companyName', {
          rules: [{
            required: true,
            errorMessage: '公司名称不能为空'
          }]
        });
      } else if (this.user.userType == 105) {
        this.$delete(this.rules, 'companyType');
        this.$delete(this.rules, 'companyName');
        this.$set(this.rules, 'governmentPosition', {
          rules: [{
            required: true,
            errorMessage: '地区不能为空'
          }]
        });
        this.$set(this.rules, 'governmentName', {
          rules: [{
            required: true,
            errorMessage: '街道不能为空'
          }]
        });
      }
      this.$refs.form.setRules(this.rules)
    }
```

