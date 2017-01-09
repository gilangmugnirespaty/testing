@CeksonComponent = React.createClass
  getInitialState: ->
    {
      products: []
      isEditing: false
      formProduct: {name: '', price: ''}
    }

  render: ->
    {products, formProduct, isEditing} = @state
    list_products = []
    products.forEach (product, index) =>
      {name, price} = product
      list_products.push(
        <tr key={index}>
          <td>{name}</td>
          <td>{price}</td>
          <td><a href='javascript:void(0)' onClick={@destroyProduct.bind(@, index)}>Delete</a></td>
          <td><a href='javascript:void(0)' onClick={@editProduct.bind(@, index)}>Edit</a></td>
        </tr>
      )

    <div>
      <h1>Panel Products</h1>
      <div>
        <p>
          Name :
          <input type="text" value={formProduct.name} onChange={@onChangedName} />
        </p>
        <p>
          Category :
          <input type="text" value={formProduct.price} onChange={@onChangedPrice} />
        </p>
        <p>
          {!isEditing && <button onClick={@insertProduct}>Insert</button>}
          {isEditing&& <button onClick={@updateProduct}>Update</button>}
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

  onChangedName: (event) ->
    {formProduct} = @state
    formProduct.name = event.target.value
    @setState formProduct: formProduct

  onChangedPrice: (event) ->
    {formProduct} = @state
    formProduct.price = event.target.value
    @setState formProduct: formProduct

  insertProduct: ->
    {formProduct, products} = @state
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
    @setState products: products

  editProduct: (index) ->
    {isEditing, formProduct, products} = @state
    product = products[index]
    formProduct.name = product.name
    formProduct.price = product.price

    @setState(
      isEditing: true
      index: index
      formProduct: formProduct
    )

  updateProduct: ->
    {formProduct, isEditing, products} = @state
    products[@state.index] = formProduct

    @setState(
      products: products
      isEditing: false
      formProduct: {name: '', price: ''}
    )
