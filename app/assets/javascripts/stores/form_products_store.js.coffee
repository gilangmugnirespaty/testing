{ EventEmitter } = fbemitter

CHANGE_EVENT = 'form-products-store:change'

# baseProduct: -> { name: '', price: '' }

window.FormProductsStore = _.assign(new EventEmitter(), {
  product: { name: '', price: '' }
  isEditing: false
  errors: []
  productId: null

  # BEGIN -- getter
  getProduct: -> @product
  getIsEditing: -> @isEditing
  getErrors: -> @errors
  getProductId: -> @productId
  # END -- getter

  # BEGIN -- emitter
  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)
  removeChangeListener: -> @removeAllListeners(CHANGE_EVENT)
  # END -- emitter
})

dispatcher.register (payload) ->
  switch payload.actionType
    when 'form-products-store:initialize'
      { product, isEditing, errors, productId } = payload

      FormProductsStore.product = product || formProduct()
      FormProductsStore.isEditing = isEditing || false
      FormProductsStore.errors = errors || []
      FormProductsStore.productId = productId || null

      FormProductsStore.emitChange()

    when 'form-products-store:name_changed'
      { event } = payload
      product = FormProductsStore.product
      product.name = event.target.value

      FormProductsStore.product = product
      FormProductsStore.emitChange()

    when 'form-products-store:price_changed'
      { event } = payload
      product = FormProductsStore.product
      product.price = event.target.value

      FormProductsStore.product = product
      FormProductsStore.emitChange()

    when 'products-index-page/products:add'
      { product } = payload
      products = TableBodyStore.products

      TableBodyStore.products = products.concat(product)
      FormProductsStore.product = { name: '', price: '' }

      FormProductsStore.emitChange()
      TableBodyStore.emitChange()

    when 'form-products-store:product/update'
      { formProduct, productId } = payload
      products = TableBodyStore.products

      map_products = products.map (product) ->
        if product.id == productId
          formProduct
        else
          product

      FormProductsStore.isEditing = false
      FormProductsStore.product = {name: '', price: ''}
      FormProductsStore.productId = null
      TableBodyStore.products = map_products

      FormProductsStore.emitChange()
      TableBodyStore.emitChange()

    when 'products-index-page/errors:set'
      { errors } = payload
      FormProductsStore.errors = errors

      FormProductsStore.emitChange()