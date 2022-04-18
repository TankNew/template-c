<template>
  <div class="container">
    <div class="page-news-detail-container">
      <div class="page-news-detail-leftbar">
        <dl>
          <dt>{{ catalogItem.catalogGroup.displayName }}</dt>
          <dd v-for="item in catelogItems.items" :key="item.id">
            <a href="javascript:void(0)" @click="goNewsDetail(item.id, 1)">{{ item.title }}</a>
          </dd>
        </dl>
      </div>
      <div class="page-news-detail-content">
        <h4 class="page-detail-title">
          <span>{{ catalogItem.title }}</span>
        </h4>
        <h6 class="page-sub-title">{{ formatDate(catalogItem.creationTime) }}</h6>
        <div class="page-content limit-width">
          <div class="news-detail">
            <div v-if="catalogItem.pictureWithInfos.length > 0 && isloaded" v-swiper:mySwiper="swiperOption">
              <div class="swiper-wrapper">
                <div v-for="slide in catalogItem.pictureWithInfos" :key="slide.id" class="swiper-slide">
                  <img :src="slide.picUrl" />
                  <div v-if="slide.picTitle || slide.picContent" class="slide-info" @click="picInfo = !picInfo">
                    <h3>{{ slide.picTitle }}</h3>
                    <p v-if="!picInfo">{{ slide.picContent }}</p>
                  </div>
                </div>
              </div>
              <div class="swiper-pagination"></div>
              <div slot="button-prev" class="swiper-button-prev"></div>
              <div slot="button-next" class="swiper-button-next"></div>
            </div>
            <div v-html="catalogItem.content"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState, mapGetters, mapMutations, mapActions } from 'vuex'
import tools from '../../../../utiltools/tools'

export default {
  data() {
    return {
      picInfo: false,
      isloaded: false,
      swiperOption: {
        pagination: {
          el: '.swiper-pagination'
        },
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev'
        },
        autoHeight: true,
        on: {
          slideChange() {},
          tap() {}
        }
      }
    }
  },
  computed: {
    ...mapState({
      culture: state => state.app.culture,
      currentPath: state => state.app.currentPath,
      companyInfo: state => state.app.companyInfo
    })
  },
  head() {
    return {
      title: this.catalogItem.title + ' - ' + this.companyInfo.appName + '-' + this.companyInfo.seoKeyWords
    }
  },
  async asyncData({ isDev, route, store, env, params, query, req, res, redirect, error }) {
    const id = route.params.id
    const catalogItem = await store.dispatch('app/getCatalog', { params: { id } })
    let path = `/${store.app.culture}/`
    switch (catalogItem.catalogGroup.catalogType) {
      case 1:
        path += 'news/' + catalogItem.catalogGroup.id
        break
      case 2:
        path += 'photonews/' + catalogItem.catalogGroup.id
        break
      case 3:
        path += 'product/' + catalogItem.catalogGroup.id
        break
    }
    const announcesParams = {
      params: {
        SkipCount: 0,
        MaxResultCount: 10
      }
    }
    const announces = (await store.dispatch('app/getAnounces', announcesParams)).items

    const catelogItemParams = {
      params: {
        IsActive: true,
        CatalogGroupId: catalogItem.catalogGroup.id,
        SkipCount: 0,
        MaxResultCount: 8
      }
    }
    const catelogItems = await store.dispatch('app/getCatalogList', catelogItemParams)

    return { catelogItems, catalogItem, path, announces }
  },
  created() {
    this.$store.dispatch('app/setcurrentPath', {
      path: this.path,
      grandId: this.catalogItem.catalogGroup.id
    })
  },
  mounted() {
    this.$nextTick(() => (this.isloaded = true))
    // this.mySwiper.slideTo(3, 1000, false)
  },
  methods: {
    target(id) {
      window.open(`/${this.culture}/announce/detail/` + String(id, '_blank'))
    },
    formatDate(val) {
      return tools.date(val)
    },
    goNewsDetail(id, type) {
      let typename
      switch (type) {
        case 1:
          typename = 'news'
          break
        case 2:
          typename = 'photonews'
          break
        case 3:
          typename = 'product'
          break
      }
      window.open(`/${this.culture}/` + typename + '/detail/' + String(id), '_blank')
    }
  }
}
</script>
