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
          <td>{{task.user_name}}</td>
          <td></td>
          <td>
          <span><a :href="task.show">Show</a></span>
          <span><a :href="task.edit">Edit</a></span>
          <span><a :href="task.delete" :data-to="task.delete" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Delete</a></span>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  props: ['tasks']
}
</script>

<style></style>