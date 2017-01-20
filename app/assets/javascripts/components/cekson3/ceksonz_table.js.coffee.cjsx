{ createClass, PropTypes } = React

@CeksonzTable = createClass
  displayName: 'CeksonzTable'

  propTypes:
    onDelete: PropTypes.func
    onEdit: PropTypes.func
    products: PropTypes.array

  render: ->
    { products } = @props
    console.log('SUDANCOK PRODUCST SSSS', products)

    row_product = products.map (product, index) =>
      <tr key={index}>
        <td>{ product.name }</td>
        <td>{ product.price }</td>
        <td><a href='javascript:void(0)' onClick={@onClickEdit.bind(@, product)}>Edit</a></td>
        <td><a href='javascript:void(0)' onClick={@onClickDelete.bind(@, product)}>Delete</a></td>
      </tr>

    <div>
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Price</th>
          </tr>
        </thead>
        <tbody>
          { row_product }
        </tbody>
      </table>
    </div>

  onClickEdit: (product) ->
    @props.onEdit(product)

  onClickDelete: (product) ->
    @props.onDelete(product)