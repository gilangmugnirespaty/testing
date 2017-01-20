{ createClass } = React

@CeksonzMain = createClass
  getInitialState: ->
    {
      products: @props.products
      formProduct: {name: '', price: ''}
      isEditing: false
    }

  render: ->
    { formProduct, products } = @state
    <div>
      <h1>Panel Products</h1>
      <CeksonzForm formProduct={formProduct} products={products} />
    </div>
