<template>
  <div>
    
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Is finished</th>
          <th>Finished at</th>
          <th>Deadline</th>
          <th>Owned by</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="task in tasks">
          <td>{{task.name}}</td>
          <td>{{task.is_finished}}</td>
          <td>{{task.finished_at}}</td>
          <td>{{task.deadline}}</td>
          <td></td>
          <td>
          <span><a href="">Show</a></span>
          <span><a href="">Edit</a></span>
          <span><a href="">Delete</a></span>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>


<script>
import axios from 'axios'
import Vue from 'vue'
export default {
  data () {
    return {
      tasks: []
    }
  },
  mounted () {
    axios.get('./api/tasks')
    .then(response => (this.tasks = response.data.data, console.log(response.data.data)))
    .catch(error => (console.log(error)))
  }
}
</script>

<style></style>