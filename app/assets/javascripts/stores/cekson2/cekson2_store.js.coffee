{ EventEmitter } = fbemitter

CHANGE_EVENT = 'cekson2:change'

window.Cekson2Store = _.assign(new EventEmitter(), {
  products: []
  isEditing: false
  formProduct: {name: '', price: ''}
  errors: []
  productId: null

  # BEGIN -- getter
  getProducts: -> @products
  getIsEditing: -> @isEditing
  getFormProduct: -> @formProduct
  getErrors: -> @errors
  getProductId: -> @getProductId
  # END -- getter

  # BEGIN -- emitter & listener
  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)
  removeChangeListener: -> @removeAllListener(CHANGE_EVENT)
  # END -- emitter & listener
})

dispatcher.register (payload) ->
  switch payload.actionType
    when 'cekson2:initialize'
      { products, isEditing, formProduct, errors } = payload

      Cekson2Store.products = products || []
      Cekson2Store.isEditing = isEditing || false
      Cekson2Store.formProduct = formProduct || {name: '', price: ''}
      Cekson2Store.errors = errors || []

      Cekson2Store.emitChange()

    when 'cekson2/products:insert'
      { products, formProduct, errors, product } = payload

      products = Cekson2Store.products
      Cekson2Store.products = products.concat(product)
      Cekson2Store.formProduct = {name: '', price: ''}

      Cekson2Store.emitChange()
      console.log('COK COK cek products', products)
      console.log('CEK CEK cek Cekson2Store.products', Cekson2Store.products)

      # formProduct = Cekson2Store.formProduct
      # product = {name: formProduct.name, price: formProduct.price}


    # when 'cekson2/errors:set'

    when 'cekson2/product:delete'
      { id_buat_di_dispatch } = payload

      products = Cekson2Store.products

      products.forEach (product) ->
        if product.id == id_buat_di_dispatch
          products.splice(index, 1)

      Cekson2Store.products = products
      Cekson2Store.emitChange()

