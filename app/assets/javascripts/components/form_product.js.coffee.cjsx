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
    {onUpdate, onInsert, isEditing} = @props
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
        {!isEditing && <button onClick={onInsert}>Insert</button>}
        {isEditing && <button onClick={onUpdate}>Update</button>}
      </p>
    </div>

  onChangedName: (event) ->
    {product} = @state
    product.name = event.target.value
    @setState product: product

  onChangedPrice: (event) ->
    {product} = @state
    product.price = event.target.value
    @setState product: product

@TableBody = createClass
  propTypes:
    onEdit: PropTypes.func.isRequired
    onDestroy: PropTypes.func.isRequired
    products: PropTypes.array.isRequired

  render: ->
    {products} = @props
    list_products = []
    products.forEach (product, index) =>
      {name, price} = product
      list_products.push(
        <TableRow
          key={index}
          onEdit={@onClickEdit.bind(@, product.id)}
          onDestroy={@onClickDestroy.bind(@, product.id)}
          product={product}
        />
      )

    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Price</th>
          <th colSpan="2">Action</th>
        </tr>
      </thead>
      <tbody>
        {list_products}
      </tbody>
    </table>

  onClickEdit: (product_id) ->
    @props.onEdit(product_id)

  onClickDestroy: (product_id) ->
    @props.onDestroy(product_id)
