{ createClass } = React

@CeksonzMain = createClass
  displayName: 'CeksonzMain'
  getInitialState: ->
    {
      products: @props.products
      formProduct: {name: '', price: ''}
      isEditing: false
      productId: null
    }

  render: ->
    { formProduct, products, productId } = @state
    <div>
      <h1>Panel Products</h1>
      <CeksonzForm formProduct={formProduct} onInsert={@onInsert} onUpdate={@onUpdate} productId={productId} products={products} />
      <CeksonzTable products={products} onEdit={@onEdit} onDelete={@onDelete} />
    </div>

  onInsert: (data) ->
    { products, formProduct } = @state
    @setState(
      products: products.concat(data)
      formProduct: { name: '', price: '' }
    )

  onUpdate: (data) ->
    { products, formProduct, productId } = @state

    map_products = products.map (_product) ->
      if _product.id == productId
        data
      else
        _product

    @setState(
      products: map_products
      formProduct: { name: '', price: '' }
      productId: null
    )

  onDelete: (product) ->
    { products } = @state

    $.ajax
      method: 'delete'
      url: Routes.product_path(product)
      dataType: 'json'
      success: =>
        products.map (_product, index) ->
          if _product.id == product.id
            products.splice(index, 1)

        @setState products: products

  onEdit: (product) ->
    @setState(
      formProduct: product
      productId: product.id
    )