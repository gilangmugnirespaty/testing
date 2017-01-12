{createClass, PropTypes} = React
@CeksonComponent = createClass
  propTypes:
    products: PropTypes.array.isRequired

  getInitialState: ->
    {
      products: @props.products
      isEditing: false
      formProduct: {name: '', price: ''}
      errors: []
    }

  render: ->
    console.log(@state.products)
    {products, formProduct, isEditing, errors} = @state
    list_errors = []
    errors.forEach (error) ->
      list_errors.push()

    <div>
      <h1>Panel Products</h1>
      <h4>{errors}</h4>
      <FormProduct product={formProduct} onInsert={@insertProduct} onUpdate={@updateProduct} isEditing={isEditing} />
      <TableBody onEdit={@editProduct} onDestroy={@destroyProduct} products={products}/>
    </div>

  insertProduct: ->
    {products, formProduct, errors} = @state
    product = {name: formProduct.name, price: formProduct.price}

    $.ajax
      method: 'post'
      url: Routes.products_path(format: 'json')
      data: {product}
      error: (data) =>
        @setState errors: data.responseJSON
        console.log(errors)
      success: (data) =>
        @setState(
          products: products.concat(data)
          formProduct: {name: '', price: ''}
        )

  destroyProduct: (product_id) ->
    {products} = @state

    $.ajax
      method: 'delete'
      url: Routes.product_path(product_id)
      dataType: 'json'
      success: =>
        products.forEach (product, index) ->
          if product.id == product_id
            products.splice(index, 1)

        @setState products: products

  editProduct: (product_id) ->
    {isEditing, formProduct, products} = @state

    products.forEach (product) ->
      if product.id == product_id
        formProduct.name = product.name
        formProduct.price = product.price

    @setState(
      isEditing: true
      formProduct: formProduct
      product_id: product_id
    )

  updateProduct: ->
    {formProduct, isEditing, products, product_id} = @state
    product = {name: formProduct.name, price: formProduct.price}

    $.ajax
      method: 'patch'
      dataType: 'json'
      url: Routes.product_path(product_id)
      data: {product}
      success: (data) =>
        map_products = products.map (product) ->
          if product.id == product_id
            product = data
          else
            product

        @setState(
          products: map_products
          isEditing: false
          formProduct: {name: '', price: ''}
          product_id: null
        )


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

@TableRow = createClass
  propTypes:
    onEdit: PropTypes.func.isRequired
    onDestroy: PropTypes.func.isRequired
    product: PropTypes.object.isRequired


  render: ->
    {onEdit, onDestroy, product} = @props
    {name, price} = product
    <tr>
      <td>{name}</td>
      <td>{price}</td>
      <td><a href='javascript:void(0)' onClick={onEdit}>Edit</a></td>
      <td><a href='javascript:void(0)' onClick={onDestroy}>Delete</a></td>
    </tr>