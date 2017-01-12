{createClass, PropTypes} = React
@CeksonComponent2 = createClass
  getInitialState: ->
    {
      products: []
      formProduct: {name: '', price: ''}
      isEditing: false
    }

  render: ->
    {products, formProduct, isEditing} = @state

    <div>
      <h1>Panel Products</h1>
      <FormInput isEditing={isEditing} formInput={formProduct} onInsert={@insertProduct} onUpdate={@updateProduct} />
      <TableParrent products={products} onEdit={@editProduct} onDestroy={@destroyProduct} />
    </div>

  insertProduct: ->
    {products, formProduct} = @state
    product = {}
    product.name = formProduct.name
    product.price = formProduct.price

    @setState(
      products: products.concat(product)
      formProduct: {name: '', price: ''}
    )

  destroyProduct: (index) ->
    {products} = @state
    products.splice(index, 1)
    @setState product: products

  editProduct: (index) ->
    {products, formProduct, isEditing} = @state
    product = products[index]
    formProduct.name = product.name
    formProduct.price = product.price

    @setState(
      index: index
      formProduct: formProduct
      isEditing: true
    )

  updateProduct: ->
    {products, formProduct, index, isEditing} = @state
    products[index] = formProduct

    @setState(
      products: products
      formProduct: {name: '', price: ''}
      index: null
      isEditing: false
    )

@FormInput = createClass
  propTypes:
    isEditing: PropTypes.bool.isRequired
    formInput: PropTypes.object.isRequired
    onInsert: PropTypes.func.isRequired
    onUpdate: PropTypes.func.isRequired

  getInitialState: ->
    {
      formInput: @props.formInput
    }

  componentWillReceiveProps: (nextProps) ->
    @setState(formInput: nextProps.formInput)

  render: ->
    {isEditing, onInsert, onUpdate} = @props
    {formInput} = @state
    <div>
      <p>
        Name :
        <input type="text" value={formInput.name} onChange={@onChangedName} />
      </p>
      <p>
        Price :
        <input type="text" value={formInput.price} onChange={@onChangedPrice} />
      </p>
      <p>
        {!isEditing && <button onClick={onInsert}>Insert</button>}
        {isEditing && <button onClick={onUpdate}>Update</button>}
      </p>
    </div>

  onChangedName: (event) ->
    {formInput} = @state
    formInput.name = event.target.value
    @setState formInput: formInput
    console.log(formInput.name)

  onChangedPrice: (event) ->
    {formInput} = @state
    formInput.price = event.target.value
    @setState formInput: formInput
    console.log(formInput.price)

@TableParrent = createClass
  propTypes:
    products: PropTypes.array.isRequired
    onEdit: PropTypes.func.isRequired
    onDestroy: PropTypes.func.isRequired

  render: ->
    { products } = @props

    list_products = []
    products.forEach (product, index) =>
      {name, price} = product
      list_products.push(
        <TableRow key={index}
          product={product}
          onEdit={@onEdit.bind(@, index)}
          onDestroy={@onDestroy.bind(@, index)} />
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

  onEdit: (index) ->
    @props.onEdit(index)

  onDestroy: (index) ->
    @props.onDestroy(index)

@TableRow = createClass
  propTypes:
    product: PropTypes.object.isRequired
    onEdit: PropTypes.func.isRequired
    onDestroy: PropTypes.func.isRequired

  render: ->
    {product, onDestroy, onEdit} = @props
    <tr>
      <td>{product.name}</td>
      <td>{product.price}</td>
      <td><a href='javascript:void(0)' onClick={onEdit}>Edit</a></td>
      <td><a href='javascript:void(0)' onClick={onDestroy}>Destroy</a></td>
    </tr>