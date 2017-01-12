{createClass, PropTypes} = React
@ProductsIndexPage = createClass
  propTypes:
    products: PropTypes.array.isRequired

  getInitialState: ->
    {
      products: @props.products
      isEditing: false
      formProduct: {name: '', price: ''}
      errors: []
    }

  render: ->
    console.log(@state.products)
    {products, formProduct, isEditing, errors} = @state
    list_errors = []
    errors.forEach (error) ->
      list_errors.push()

    <div>
      <h1>Panel Products</h1>
      <h4>{errors}</h4>
      <FormProduct product={formProduct} onInsert={@insertProduct} onUpdate={@updateProduct} isEditing={isEditing} />
      <TableBody onEdit={@editProduct} onDestroy={@destroyProduct} products={products}/>
    </div>

  insertProduct: ->
    {products, formProduct, errors} = @state
    product = {name: formProduct.name, price: formProduct.price}

    $.ajax
      method: 'post'
      url: Routes.products_path(format: 'json')
      data: {product}
      error: (data) =>
        @setState errors: data.responseJSON
        console.log(errors)
      success: (data) =>
        @setState(
          products: products.concat(data)
          formProduct: {name: '', price: ''}
        )

  destroyProduct: (product_id) ->
    {products} = @state

    $.ajax
      method: 'delete'
      url: Routes.product_path(product_id)
      dataType: 'json'
      success: =>
        products.forEach (product, index) ->
          if product.id == product_id
            products.splice(index, 1)

        @setState products: products

  editProduct: (product_id) ->
    {isEditing, formProduct, products} = @state

    products.forEach (product) ->
      if product.id == product_id
        formProduct.name = product.name
        formProduct.price = product.price

    @setState(
      isEditing: true
      formProduct: formProduct
      product_id: product_id
    )

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