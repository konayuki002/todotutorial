<template>
  <div>
    <h1>Listing Tasks</h1>      
      <label for="is_finished_checkbox">Is finished</label>
      <input type="checkbox" id="is_finished_checkbox" v-model="is_finished">
      <label for="is_expired_checkbox">Is expired</label>
      <input type="checkbox" id="is_expired_checkbox" v-model="is_expired">
      <label for="user_select">User</label>
      <select id="user_select" v-model="user_id">
        <option v-for="user in users" v-bind:value="user.id">
          {{ user.name }}
        </option>
        <option value="nil" selected>指定しない</option>
      </select>
      <div>
        <button v-on:click="fetch_tasks">filter</button>
      </div>
    <List v-bind:tasks="tasks"></List>
    <span><a href="/tasks/new">New Task</a></span>
  </div>
</template>

<script>
import List from './list.vue'
import axios from 'axios'
export default {
  name: "task_index",
  components: { List },
  data() {
    return {
      users: [],
      is_finished: false,
      is_expired: false,
      user_id: "nil",
      tasks: []
    }
  },
  methods: {
    fetch_tasks: async function() {
      const response = await axios.get('/api/tasks',{
        params: {
          is_finished: this.is_finished,
          is_expired: this.is_expired,
          user_id: this.user_id
        }
      })
      .catch(error => (console.log(error)))
      this.tasks = response.data.data
    }
  },
  async mounted () {
    const response = await axios.get('/api/users').catch(error => (console.log(error)))
    this.users = response.data.data
    this.fetch_tasks()
  }
}
</script>

<style></style>