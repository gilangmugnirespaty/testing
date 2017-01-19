{createClass, PropTypes} = React
@FormProduct = createClass
  getInitialState: ->
    {
      product: FormProductsStore.getProduct()
      isEditing: FormProductsStore.getIsEditing()
      errors: FormProductsStore.getErrors()
      productId: FormProductsStore.getProductId()
    }

  # componentWillReceiveProps: (nextProps) ->
  #   @setState(product: nextProps.product)

  componentDidMount: ->
    FormProductsStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    FormProductsStore.removeChangeListener()

  render: ->
    {isEditing, errors, product} = @state
    list_error = []

    errors.forEach (error) ->
      list_error.push(error)

    <div>
      <p>
        { list_error }
      </p>
      <p>
        Name :
        <input type="text" value={product.name} onChange={@onChangedName} />
      </p>
      <p>
        Price :
        <input type="number" value={product.price} onChange={@onChangedPrice} />
      </p>
      <p>
        {!isEditing && <button onClick={@insertProduct}>Insert</button>}
        {isEditing && <button onClick={@updateProduct}>Update</button>}
      </p>
    </div>

  # onClickInsert: ->
  #   @props.onInsert(@state.product)

  # onClickUpdate: ->
  #   @props.onUpdate(@state.product)

  onChangedName: (event) ->
    # {product} = @state
    # product.name = event.target.value
    # @setState product: product
    { product } = @state
    dispatcher.dispatch
      actionType: 'form-products-store:name_changed'
      event: event

  onChangedPrice: (event) ->
    { product } = @state
    # {product} = @state
    # product.price = event.target.value
    # @setState product: product
    dispatcher.dispatch
      actionType: 'form-products-store:price_changed'
      event: event

  # insertProduct: (product) -> # dri mana product nya
  insertProduct: ->
    { product } = @state
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

  updateProduct: ->
    # {formProduct, isEditing, products, product_id} = @state
    # product = {name: formProduct.name, price: formProduct.price}

    # $.ajax
    #   method: 'patch'
    #   dataType: 'json'
    #   url: Routes.product_path(product_id)
    #   data: {product}
    #   success: (data) =>
    #     map_products = products.map (product) ->
    #       if product.id == product_id
    #         product = data
    #       else
    #         product

    #     @setState(
    #       products: map_products
    #       isEditing: false
    #       formProduct: {name: '', price: ''}
    #       product_id: null
    #     )
    {product, productId} = @state

    $.ajax
      method: 'patch'
      dataType: 'json'
      url: Routes.product_path(productId)
      data: { product: product }
      success: (data) =>
        dispatcher.dispatch
          actionType: 'form-products-store:product/update'
          formProduct: data
          productId: productId

  _onChange: ->
    @setState
      isEditing: FormProductsStore.getIsEditing()
      product: FormProductsStore.getProduct()
      errors: FormProductsStore.getErrors()
      productId: FormProductsStore.getProductId()

