@ProductsPage = React.createClass
  getInitialState: ->
    {
      products : @props.products
      index: null
      isEditing: false
    }

  insertProduct: ->
    product = {}
    product.name = $('#inputProduct').val()
    product.price = $('#inputPrice').val()
    @setState products: @state.products.concat(product)
    $('#inputProduct').val(null)
    $('#inputPrice').val(null)

  deleteProduct: (index) ->
    { products } = @state
    products.splice(index, 1);
    @setState products: products

  editProduct: (index) ->
    product = @state.products[index]
    @setState
      index: index
      isEditing: true

    $('#inputProduct').val(product.name)
    $('#inputPrice').val(product.price)

  updateProduct: ->
    index = @state.index
    products = @state.products
    product = products[index]

    product.name = $('#inputProduct').val()
    product.price = $('#inputPrice').val()

    @setState
      products: products
      isEditing: false

    $('#inputPrice').val(null)
    $('#inputProduct').val(null)

  render: ->
    list_products = @state.products
    _this = this

    @state.products.forEach (product, index) =>
      { name, price } = product

      list_products.push(
        <tr key={index}>
          <td>{name}</td>
          <td>{price}</td>
          <td><a href='javascript:void(0)' onClick={@deleteProduct.bind(_this, index)}>Delete</a></td>
          <td><a href='javascript:void(0)' onClick={@editProduct.bind(_this, index)}>Edit</a></td>
        </tr>
      )

    <div>
      <h1>Panel Products</h1>
      <div>
        <p>
          Name :
          <input id="inputProduct" type="text" />
        </p>
        <p>
          Price :
          <input id="inputPrice" type="text" />
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
