<template>
  <div>
    <h1>Listing Tasks</h1>
      <form>
        <label for="is_finished">Is finished</label>
        <input type="checkbox" id="is_finished">
        <label for="is_expired">Is expired</label>
        <input type="checkbox" id="is_expired">
        <label for="user_id">User</label>
        <select id="user_id">
          <option v-for="user in users" v-bind:value="user.id">
            {{ user.name }}
          </option>
        </select>
        <div>
          <input type="submit" value="filter">
        </div>
      </form>
    <List></List>
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
      users: []
    }
  },
  mounted () {
    axios.get('/api/users')
    .then(response => {
      this.users = response.data.data;
      console.log(response);
      })
    .catch(error => (console.log(error)))
  }
}
</script>

<style></style>