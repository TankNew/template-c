<template>
  <div class="page-content limit-width" v-html="pageContent.content"></div>
</template>
<script>
export default {
  async asyncData({ isDev, route, store, env, params, query, req, res, redirect, error }) {
    const json = await store.dispatch('app/getPage', { params: { id: route.params.id } })

    return { pageContent: json }
  }
}
</script>
