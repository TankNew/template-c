export default function({ $axios, store, app, redirect, $config }) {
  $axios.onRequest(
    config => {
      config.headers.common[store.state.app.headerName] = store.getters['app/getCulture']

      const multiTenancyHeader = 'Abp.TenantId'
      const multiTenancy = app.$cookies.get(multiTenancyHeader)
      // 加载ID环境变量
      config.headers.common[multiTenancyHeader] = $config.NUXT_ENV_TENANT_ID
      return config
    },
    function(error) {
      return Promise.reject(error)
    }
  )

  $axios.onResponse(
    response => {
      return response
    },
    error => {
      if (
        !!error.response &&
        !!error.response.data.error &&
        !!error.response.data.error.message &&
        error.response.data.error.details
      ) {
        console.error(error.response.data.error.message)
        console.error(error.response.data.error.details)
      } else if (!!error.response && !!error.response.data.error && !!error.response.data.error.message) {
        console.error(error.response.data.error.message)
        redirect('/error')
      } else if (!error.response) {
        console.error('no response')
      }
      console.error('ajax error')
      return Promise.reject(error)
    }
  )
}
