{createClass, PropTypes} = React
@TableBody = createClass
  # propTypes:
  #   onEdit: PropTypes.func.isRequired
  #   onDestroy: PropTypes.func.isRequired
  #   products: PropTypes.array.isRequired

  getInitialState: ->
    {
      products: TableBodyStore.getProducts()
    }

  componentDidMount: ->
    TableBodyStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    TableBodyStore.removeChangeListener()

  render: ->
    {products} = @state
    list_products = []
    products.forEach (product, index) =>
      {name, price} = product
      list_products.push(
        <TableCekson1Row
          key={index}
          onEdit={@editProduct.bind(@, product.id)}
          onDestroy={@destroyProduct.bind(@, product.id)}
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
        { list_products }
      </tbody>
    </table>

  # onClickEdit: (productId) ->
  #   @props.onEdit(productId)

  # onClickDestroy: (productId) ->
  #   @props.onDestroy(productId)

  destroyProduct: (productId) ->
    # {products} = @state
    alert('Data was successfully destroyed')
    $.ajax
      method: 'delete'
      url: Routes.product_path(productId)
      dataType: 'json'
      success: ->
        dispatcher.dispatch
          actionType: 'table-body-store:product/delete'
          productId: productId

  editProduct: (productId) ->
    # {isEditing, formProduct, products} = @state

    # products.forEach (product) ->
    #   if product.id == product_id
    #     formProduct.name = product.name
    #     formProduct.price = product.price

    # @setState(
    #   isEditing: true
    #   formProduct: formProduct
    #   product_id: product_id
    # )

    dispatcher.dispatch
      actionType: 'table-body-store:product/edit'
      productId: productId

  _onChange: ->
    @setState
      products: TableBodyStore.getProducts()
