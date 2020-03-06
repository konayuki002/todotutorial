<template>
  <div>
    <h1>Listing Tasks</h1>
    ここに検索
    <List></List>
    <span><a href="???">New Task</a></span>
  </div>
</template>

<script>
import List from './list.vue'
export default {
  name: "task_index",
  components: { List },
  data() {
    return {

    }
  }
}
</script>

<style></style>