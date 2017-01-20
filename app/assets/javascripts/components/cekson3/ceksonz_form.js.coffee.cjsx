{ createClass, PropTypes } = React

@CeksonzForm = createClass
  displayName: 'CeksonzForm'

  propTypes:
    onInsert: PropTypes.func
    formProduct: PropTypes.object
    productId: PropTypes.number
    onUpdate: PropTypes.func

  getInitialState: ->
    {
      products: @props.products
      formProduct: @props.formProduct
      productId: @props.productId
    }

  componentWillReceiveProps: (nextProps) ->
    @setState(formProduct: nextProps.formProduct)

  render: ->
    { products, formProduct } = @state
    { name, price } = formProduct
    <div>
      <p>
        Name:
        <input type="text" value={name} onChange={@onChangedName} />
      </p>
      <p>
        Price:
        <input type="number" value={price} onChange={@onChangedPrice} />
      </p>
      <p>
        <button onClick={@onInsert}>Insert</button>
        <button onClick={@onUpdate}>Update</button>
      </p>
    </div>

  onChangedName: (event) ->
    { formProduct } = @state
    formProduct.name = event.target.value
    @setState formProduct: formProduct

  onChangedPrice: (event) ->
    { formProduct } = @state
    formProduct.price = event.target.value
    @setState formProduct: formProduct

  onInsert: ->
    { products, formProduct } = @state
    product = { name: formProduct.name, price: formProduct.price }

    $.ajax
      method: 'post'
      url: Routes.products_path(format: 'json')
      data: { product: product }
      success: (data) =>
        @props.onInsert(data)

  onUpdate: ->
    { products, formProduct } = @state
    { productId } = @props
    product = { name: formProduct.name, price: formProduct.price }
    console.log(products)
    $.ajax
      method: 'patch'
      dataType: 'json'
      url: Routes.product_path(productId)
      data: {product}
      success: (data) =>
        @props.onUpdate(data)