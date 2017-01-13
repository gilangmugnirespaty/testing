{createClass, PropTypes} = React
@ProductsIndexPage = createClass
  propTypes:
    products: PropTypes.array.isRequired

  getInitialState: ->
    {
      products: ProductsIndexPageStore.getProducts()
      isEditing: ProductsIndexPageStore.getIsEditing()
      formProduct: ProductsIndexPageStore.getFormProduct()
      errors: ProductsIndexPageStore.getErrors()
    }

  componentDidMount: ->
    ProductsIndexPageStore.addChangeListener(@_onChange)
    console.log(@state.errors)

  componentWillUnmount: ->
    productsIndexPageStore.removeChangeListener()

  render: ->
    console.log(@state.products)
    {products, formProduct, isEditing, errors} = @state
    list_errors = []
    console.log(errors)
    errors.forEach (error) ->
      list_errors.push()

    <div>
      <h1>Panel Products</h1>
      <h4>{errors}</h4>
      <FormProduct product={formProduct} onInsert={@insertProduct} onUpdate={@updateProduct} isEditing={isEditing} />
      <TableBody onEdit={@editProduct} onDestroy={@destroyProduct} products={products}/>
    </div>

  insertProduct: (product) ->
    product = { name: product.name, price: product.price }

    $.ajax
      method: 'post'
      url: Routes.products_path(format: 'json')
      data: { product: product }
      success: (data) ->
        dispatcher.dispatch
          actionType: 'products-index-page/products:add'
          product: data
      error: (data) ->
        dispatcher.dispatch
          actionType: 'products-index-page/errors:set'
          errors: data.responseJSON

  destroyProduct: (productId) ->
    # {products} = @state

    $.ajax
      method: 'delete'
      url: Routes.product_path(productId)
      dataType: 'json'
      success: ->
        dispatcher.dispatch
          actionType: 'products-index-page/product:delete'
          productId: productId

  editProduct: (productId) ->
    # {isEditing, formProduct, products} = @state

    # products.forEach (product) ->
    #   if product.id == product_id
    #     formProduct.name = product.name
    #     formProduct.price = product.price

    # @setState(
    #   isEditing: true
    #   formProduct: formProduct
    #   product_id: product_id
    # )

    dispatcher.dispatch
      actionType: 'products-index-page/product:edit'
      productId: productId


  updateProduct: ->
    {formProduct, isEditing, products, product_id} = @state
    product = {name: formProduct.name, price: formProduct.price}

    $.ajax
      method: 'patch'
      dataType: 'json'
      url: Routes.product_path(product_id)
      data: {product}
      success: (data) =>
        map_products = products.map (product) ->
          if product.id == product_id
            product = data
          else
            product

        @setState(
          products: map_products
          isEditing: false
          formProduct: {name: '', price: ''}
          product_id: null
        )

    # $.ajax
    #   method: 'patch'
    #   dataType: 'json'
    #   url: Routes.product_path()
    #   data:
    #   success:

  _onChange: ->
    console.log("TEST")
    @setState
      products: ProductsIndexPageStore.getProducts()
      isEditing: ProductsIndexPageStore.getIsEditing()
      formProduct: ProductsIndexPageStore.getFormProduct()
      errors: ProductsIndexPageStore.getErrors()
