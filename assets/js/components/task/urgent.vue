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
    get_tasks: function() {
      axios.get('/api/urgent')
      .then(response => {
        response.data.data.urgent_tasks.map(
          task => (
            task.show = '/tasks/' + task.id,
            task.edit = '/tasks/' + task.id + '/edit',
            task.delete = '/api/tasks/' + task.id
          )
        )
        this.urgent_tasks = response.data.data.urgent_tasks
        response.data.data.expired_tasks.map(
            task => (
                task.show = '/tasks/' + task.id,
                task.edit = '/tasks/' + task.id + '/edit',
                task.delete = '/api/tasks/' + task.id
            )
        )
        this.expired_tasks = response.data.data.expired_tasks
      })
      .catch(error => (console.log(error)))
    }
  },
  mounted () {
    this.get_tasks()
  }
}
</script>

<style></style>