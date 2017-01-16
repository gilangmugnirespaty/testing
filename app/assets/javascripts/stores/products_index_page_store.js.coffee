{ EventEmitter } = fbemitter

BATMAN = 'products-index-page:change'

# Proses yang di analogikan sebagai model pada rails, dimana kita meng initialize seluruh state yang akan di pass ke react component
window.ProductsIndexPageStore = _.assign(new EventEmitter(), {
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
  getProductId: -> @productId
  # END -- getter

  # BEGIN -- emitter & listener
  # emitter ialah penuju perubahan pada state.. lampu batman di apungkan ke langit
  # listener ap nya can bsa mengsimpulkan callback yang diterima dari file react onchange jadi bruce wayne callback maybe?
  emitChange: -> @emit(BATMAN)
  addChangeListener: (callbackz) -> @addListener(BATMAN, callbackz)
  removeChangeListener: -> @removeAllListener(BATMAN) # removeAllListener
  # END -- emitter & listener
})

  # tah ieu bisa di analogikan sebagai controller di rails, nanti ada method/action yg akan di eksekusi berdasarkan attribute
  # yang di terima dari componen react
  # tah ieu teh dispatcher nu index anu payload tea anu anu anu ane can apal
  # jadi setState nu di component react ngan hiji, di onchange tea lamun di fungsi update insert teh setState na diubah jadi dispatch
dispatcher.register (payload) -> # tah ieu teh apeu
  switch payload.actionType
    when 'products-index-page:initialize'
      {products, isEditing, formProduct, errors} = payload

      ProductsIndexPageStore.products = products || []
      ProductsIndexPageStore.isEditing = isEditing || false
      ProductsIndexPageStore.formProduct = formProduct || {name: '', price: ''}
      ProductsIndexPageStore.errors = errors || []

      console.log('payload initialize', payload)
      console.log('products', products)
      console.log('isEditing', isEditing)
      console.log('formProduct', formProduct)
      console.log('errors', errors)
      ProductsIndexPageStore.emitChange()

    # when 'products-index-page/formProduct:insert'
    #   {products, formProduct, errors} = payload

    #   ProductsIndexPageStore.products = products
    #   ProductsIndexPageStore.formProduct = formProduct
    #   ProductsIndexPageStore.errors = errors

    #   ProductsIndexPageStore.emitChange()

    when 'products-index-page/errors:set'
      { errors } = payload

      ProductsIndexPageStore.errors = errors || []

      ProductsIndexPageStore.emitChange()

    when 'products-index-page/products:add'
      { product } = payload
      products = ProductsIndexPageStore.products

      ProductsIndexPageStore.products = products.concat(product)
      ProductsIndexPageStore.formProduct = {name: '', price: ''}

      ProductsIndexPageStore.emitChange()

    when 'products-index-page/product:delete'
      { productId } = payload

      products = ProductsIndexPageStore.products

      products.forEach (product, index) ->
        if product.id == productId
          products.splice(index, 1)

      ProductsIndexPageStore.products = products

      ProductsIndexPageStore.emitChange()

    when 'products-index-page/product:edit'
      { productId, products } = payload
      products = ProductsIndexPageStore.products
      formProduct = ProductsIndexPageStore.formProduct

      products.forEach (product) ->
        if product.id == productId
          formProduct.name = product.name
          formProduct.price = product.price

      ProductsIndexPageStore.isEditing = true
      ProductsIndexPageStore.formProduct = formProduct
      ProductsIndexPageStore.productId = productId

      console.log('edit', payload)
      console.log('products', products)
      console.log('productId', productId)

      ProductsIndexPageStore.emitChange()

    when 'products-index-page/product:update'
      { formProduct, productId } = payload
      products = ProductsIndexPageStore.products
      console.log('cek formProduct in update', formProduct)
      map_products = products.map (product) ->
        if product.id == productId
          formProduct
        else
          product

      ProductsIndexPageStore.isEditing = false
      ProductsIndexPageStore.formProduct = {name: '', price: ''}
      ProductsIndexPageStore.products = map_products
      ProductsIndexPageStore.productId = null

      ProductsIndexPageStore.emitChange()

      console.log('in update want cekson products', products )
