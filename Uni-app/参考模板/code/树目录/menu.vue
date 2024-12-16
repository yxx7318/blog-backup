<template>
	<uni-data-menu :localdata="currentMenus" :unique-opened="false" :active="activeUrl" active-text-color="#409eff"
		@select="select" @open="onOpen" @close="onClose"></uni-data-menu>
</template>

<script>
	
	export default {
		data() {
			return {
				currentMenus: [],
			}
		},
		props: {
			initData: Function
		},
		created() {
			this.getMenus()
		},
		methods: {
			getBase(item, icon='') {
				return {
					menu_id: item.treeId,
					text: item.name,
					icon: icon,
					value: item.treeId,
				}
			},
			getchildren(parent, item) {
				parent.icon = 'uni-icons-list'
				if (!!parent.children) {
					parent.children.push(this.getBase(item))
				} else {
					parent.children = [this.getBase(item)]
				}
			},
			// 递归
			recursion(currentItem, targetId) {
				// 递归出口
				for (let item of currentItem) {
					if (item.menu_id == targetId) {
						return item
					}
					if (item.children && item.children.length > 0) {
						let result = this.recursion(item.children, targetId)
						if (result) {
							return result
						}
					}
				}
				return null
			},
			getMenus() {
				this.initData().then((res) => {
					for (let i of res.data) {
						// 通过父id查找
						let found = this.recursion(this.currentMenus, i.parentId)
						if (found) {
							// 添加子节点进去
							this.getchildren(found, i)
						} else {
							this.currentMenus.push(this.getBase(i, 'uni-icons-list'))
						}
					}
					// console.log(this.currentMenus)
				})
			},
			select(e) {
				// const value = e.value
				// console.log('----select value:', e)
				this.$emit("selectChange", e)
			},
			onOpen(key) {
				this.$emit('open', key)
			},
			onClose(key) {
				this.$emit('close', key)
			}
		}
	}
</script>
