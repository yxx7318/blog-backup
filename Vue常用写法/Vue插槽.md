# Vue插槽

```vue
        <el-table-column prop="weekday" label="开放时间" v-if="isTakeOut">
          <template slot-scope="scope">
            <el-tag v-for="(item, index) in scope.row.weekday" :key="index">{{ getWeekday(item) }}</el-tag>
          </template>
        </el-table-column>
```

```vue
      <el-table-column class-name="status-col" label="Status" width="110" align="center">
        <!-- scope.row.status就是访问这个对象的status属性。只要表格数据源（即el-table的data属性）中的对象含有status属性 -->
        <template slot-scope="scope">
          <el-tag :type="scope.row.status | statusFilter">{{ scope.row.status }}</el-tag>
        </template>
      </el-table-column>



export default {
  filters: {
    statusFilter(status) {
      const statusMap = {
        published: 'success',
        draft: 'gray',
        deleted: 'danger'
      }
      return statusMap[status]
    }
  },
}
```

> `slot-scope`已弃用，使用`v-slot`进行替代
>
> `:type="scope.row.status | statusFilter"`：这里使用 Vue 的动态绑定（`:type`），将 `scope.row.status` 通过 `statusFilter` 过滤器进行处理，然后设置为标签的类型

