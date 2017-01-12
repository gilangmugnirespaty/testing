{ createClass, PropTypes } = React

@ProductsPage = createClass
  getInitialState: ->
    {
      products: []
      index: null
      isEditing: false
      name: ''
      price: ''
    }

  componentDidMount: ->
    # _this = this

    # $.ajax
    #   url: 'products.json'
    #   method: 'GET'
    #   beforeSend: ->
    #     _this.setState { isLoading: true }
    #   success: (data) ->
    #     _this.setState { isLoading: false }
    #     _this.setState { products: data }

  render: ->
    # if @state.isLoading
    #   return <p>Loading...</p>

    list_products = []
    @state.products.forEach (product, index) =>
      list_products.push(
        <TableRow key={index} product={product} onEdit={@editProduct.bind(@, index)} onDelete={@deleteProduct.bind(@, index)} />
      )

    <div>
      <h1>Panel Products</h1>
      <div>
        <p>
          Name :
          <input type="text" value={@state.name} onChange={@onNameChanged}/>
        </p>
        <p>
          Price :
          <input type="text" value={@state.price} onChange={@onPriceChanged}/>
        </p>
        <p>
          { !@state.isEditing && <button id='insertButton' onClick={@insertProduct}>Insert</button> }
          { @state.isEditing && <button id='updateButton' onClick={@updateProduct}>Update</button> }
        </p>
      </div>
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
    </div>

  insertProduct: ->
    product = {}
    product.name = @state.name
    product.price = @state.price

    @setState
      products: @state.products.concat(product)
      name: ''
      price: ''

  deleteProduct: (index) ->
    { products } = @state
    products.splice(index, 1);
    @setState(products: products)

  editProduct: (index) ->
    product = @state.products[index]
    name = product.name
    price = product.price

    @setState
      index: index
      isEditing: true
      name: name
      price: price

  updateProduct: ->
    products = @state.products
    product = products[@state.index]
    product.name = @state.name
    product.price = @state.price

    @setState
      name: ''
      price: ''
      isEditing: false
      products: products

  onNameChanged: (event) ->
    name = event.target.value
    console.log(name)
    @setState(name: name)

  onPriceChanged: (event) ->
    price = event.target.value

    @setState(price: price)
    console.log(price)


TableRow = createClass
  propTypes:
    product: PropTypes.object.isRequired
    onEdit: PropTypes.func.isRequired
    onDelete: PropTypes.func.isRequired

  render: ->
    { product, onEdit, onDelete } = @props
    { name, price } = product
    console.log(name)
    <tr>
      <td>{name}</td>
      <td>{price}</td>
      <td><a href='javascript:void(0)' onClick={onDelete}>Delete</a></td>
      <td><a href='javascript:void(0)' onClick={onEdit}>Edit</a></td>
    </tr>