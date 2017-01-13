{createClass, PropTypes} = React
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
