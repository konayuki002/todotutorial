<template>
  <div>
    <h1>Urgent Tasks</h1>  
        <List v-bind:tasks="urgent_tasks"></List>
    <h1>Expired Tasks</h1>
        <List v-bind:tasks="expired_tasks"></List>
    <span><a href="/tasks/new">New Task</a></span>
  </div>
</template>

<script>
import List from './list.vue'
import axios from 'axios'
export default {
  name: "urgent",
  components: { List },
  data() {
    return {
      urgent_tasks: [],
      expired_tasks: []
    }
  },
  methods: {
    get_tasks: async function() {
      const response = await axios.get('/api/urgent').catch(error => console.log(error))
      this.urgent_tasks = response.data.data.urgent_tasks
      this.expired_tasks = response.data.data.expired_tasks
    }
  },
  mounted () {
    this.get_tasks()
  }
}
</script>

<style></style>