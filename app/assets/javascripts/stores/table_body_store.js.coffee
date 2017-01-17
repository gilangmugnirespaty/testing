{ EventEmitter } = fbemitter

CHANGE_EVENT = 'table-body-store:change'

window.TableBodyStore = _.assign(new EventEmitter(), {
  products: []

  # BEGIN -- getter
  getProducts: -> @products
  # END -- getter

  # BEGIN -- emitter & listener
  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)
  removeChangeListener: -> @removeAllListeners(CHANGE_EVENT)
  # END -- emitter & listener
})

dispatcher.register (payload) ->
  switch payload.actionType
    when 'table-body-store:initialize'
      { products } = payload

      TableBodyStore.products = products || []

    when 'table-body-store:product/edit'
      { productId } = payload
      products = TableBodyStore.products
      formProduct = FormProductsStore.product

      products.forEach (product) ->
        if product.id == productId
          formProduct.name = product.name
          formProduct.price = product.price

      FormProductsStore.isEditing = true
      FormProductsStore.product = formProduct
      FormProductsStore.productId = productId

      FormProductsStore.emitChange()

    when 'table-body-store:product/delete'
      { productId } = payload
      products = TableBodyStore.products

      products.forEach (product, index) ->
        if product.id == productId
          products.splice(index, 1)

      TableBodyStore.products = products
      TableBodyStore.emitChange()


