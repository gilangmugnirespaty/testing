{createClass, PropTypes} = React
@CeksonComponent2 = createClass
  getInitialState: ->
    {
      products: Cekson2Store.getProducts()
      formProduct: Cekson2Store.getFormProduct()
      isEditing: Cekson2Store.getIsEditing()
      productId: Cekson2Store.getProductId()
    }

  componentDidMount: ->
    Cekson2Store.addChangeListener(@_onChange)

  componentWillUnmount: ->
    Cekson2Store.removeChangeListener()

  render: ->
    {products, formProduct, isEditing} = @state

    <div>
      <h1>Panel Products</h1>
      <FormInput isEditing={isEditing} formInput={formProduct} onInsert={@insertProduct} onUpdate={@updateProduct} />
      <TableParrent products={products} onEdit={@editProduct} onDestroy={@destroyProduct} />
    </div>

  insertProduct: ->
    # {products, formProduct} = @state
    # product = {name: formProduct.name, price: formProduct.price}

    # @setState(
    #   products: products.concat(product)
    #   formProduct: {name: '', price: ''}
    # )


    { formProduct } = @state
    product = {name: formProduct.name, price: formProduct.price}

    # dispatcher.dispatch
    #   actionType: 'cekson2/products:insert'
    #   product: product

    $.ajax
      method: 'post'
      url: Routes.products_path(format: 'json')
      data: { product: product }
      success: (data) ->
        dispatcher.dispatch
          actionType: 'cekson2/products:insert'
          product: data
      error: (data) ->
        dispatcher.dispatch
          actionType: 'cekson2/errors:set'
          errors: data.responseJSON

  destroyProduct: (productId) ->
    # {products} = @state
    # products.splice(index, 1)
    # @setState product: products

    # alert(productId)

    $.ajax
      method: 'delete'
      url: Routes.product_path(productId)
      dataType: 'json'
      success: ->
        dispatcher.dispatch
          actionType: 'cekson2/product:delete'
          id_buat_di_dispatch: productId


  editProduct: (productId) ->
    # {products, formProduct, isEditing} = @state
    # product = products[index]
    # formProduct.name = product.name
    # formProduct.price = product.price

    # @setState(
    #   index: index
    #   formProduct: formProduct
    #   isEditing: true
    # )

    dispatcher.dispatch
      actionType: 'cekson2/product:edit'
      id_buat_di_dispatch: productId

  updateProduct: ->
    # {products, formProduct, index, isEditing} = @state
    # products[index] = formProduct

    # @setState(
    #   products: products
    #   formProduct: {name: '', price: ''}
    #   index: null
    #   isEditing: false
    # )

    { productId, formProduct } = @state

    $.ajax
      method: 'patch'
      dataType: 'json'
      url: Routes.product_path(productId)
      data: { product: formProduct }
      success: (data) ->
        dispatcher.dispatch
          actionType: 'cekson2/product:update'
          formProduct: data
          id_buat_di_dispatch: productId

  _onChange: ->
    console.log("Set State")
    @setState
      products: Cekson2Store.getProducts()
      isEditing: Cekson2Store.getIsEditing()
      formProduct: Cekson2Store.getFormProduct()
      errors: Cekson2Store.getErrors()
      productId: Cekson2Store.getProductId()



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
          onEdit={@onEdit.bind(@, product.id)}
          onDestroy={@onDestroy.bind(@, product.id)} />
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

  onEdit: (productId) ->
    @props.onEdit(productId)

  onDestroy: (productId) ->
    @props.onDestroy(productId)

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
