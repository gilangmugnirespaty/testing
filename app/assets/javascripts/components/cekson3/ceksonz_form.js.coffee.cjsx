{ createClass } = React

@CeksonzForm = createClass

  getInitialState: ->
    {
      products: @props.products
      formProduct: @props.formProduct
    }

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
        <input type="text" value={price} onChange={@onChangedPrice} />
      </p>
      <p>
        <button onClick={onInsert}>Insert</button>
        <button onClick={onUpdate}>Update</button>
      </p>
    </div>

  onChangedName: (event) ->
   { formProduct } = @state
   formProduct.name = event.target.value
   @setState formProduct: formProduct
   console.log "name", formProduct.name

  onChangedPrice: (event) ->
    { formProduct } = @state
    formProduct.price = event.target.value
    @setState formProduct: formProduct
    console.log "price", formProduct.price