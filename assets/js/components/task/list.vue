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
        <tr v-for="(task, index) in tasks">
          <td>{{task.name}}</td>
          <td>{{task.is_finished}}</td>
          <td>{{task.finished_at}}</td>
          <td>{{task.deadline}}</td>
          <td>{{task.user.name}}</td>
          <td></td>
          <td>
          <span><a :href="`/tasks/${task.id}`">Show</a></span>
          <span><a :href="`/tasks/${task.id}/edit`">Edit</a></span>
          <span><a @click="delete_task(task.id, index)">Delete</a></span>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  props: ['tasks'],
  methods: {
    delete_task: async function(id, index) {
      if(confirm("Are you sure?")){
        const response = await axios.delete(`/api/tasks/${id}`).catch(error => (console.log(error)))
        if(response.status == 204){
          this.tasks.splice(index, 1)
        }
      }
    }
  }
}
</script>

<style></style>