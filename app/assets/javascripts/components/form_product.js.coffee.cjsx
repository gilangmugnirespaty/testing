{createClass, PropTypes} = React
@FormProduct = createClass
  propTypes:
    product: PropTypes.object.isRequired
    onInsert: PropTypes.func.isRequired
    onUpdate: PropTypes.func.isRequired
    isEditing: PropTypes.bool.isRequired

  getInitialState: ->
    {
      product: @props.product
    }

  componentWillReceiveProps: (nextProps) ->
    @setState(product: nextProps.product)

  render: ->
    {onUpdate, isEditing} = @props
    {product} = @state
    <div>
      <p>
        Name :
        <input type="text" value={product.name} onChange={@onChangedName} />
      </p>
      <p>
        Price :
        <input type="number" value={product.price} onChange={@onChangedPrice} />
      </p>
      <p>
        {!isEditing && <button onClick={@onClickInsert}>Insert</button>}
        {isEditing && <button onClick={onUpdate}>Update</button>}
      </p>
    </div>

  onClickInsert: ->
    @props.onInsert(@state.product)

  onChangedName: (event) ->
    {product} = @state
    product.name = event.target.value
    @setState product: product

  onChangedPrice: (event) ->
    {product} = @state
    product.price = event.target.value
    @setState product: product

