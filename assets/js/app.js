// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

import Vue from 'vue'
import index from './components/page/index.vue'
import task_index from './components/task/index.vue'
import axios from 'axios'

new Vue({
    el: '#vue',
    components: { index }
})

var vm = new Vue({
  el: '#vue',
  components: { task_index }
})

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
