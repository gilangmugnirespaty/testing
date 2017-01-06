@UsersPage = React.createClass
  getInitialState: ->
    {
      users: []
      isEditing: false
      name: ''
      age: ''
    }

  onNameChanged: (event)->
    console.log(event.target.value)
    @setState name: event.target.value

  onAgeChanged: (event)->
    console.log(event.target.value)
    @setState age: event.target.value

  insertUser: ->
    user = { name: @state.name, age: @state.age }
    @setState users: @state.users.concat(user)
    @setState { name: '', age: '' }

  destroyUser: (index) ->
    users = @state.users
    users.splice(index, 1)
    @setState users: users

  clearForm: ->
    @setState { name: '', age: '' }

  editUser: (index) ->
    user = @state.users[index]
    @setState(
      index: index
      isEditing: true
      name: user.name
      age: user.age
    )

  updateUser: ->
    users = @state.users
    user = users[@state.index]
    user.name = @state.name
    user.age = @state.age
    @setState(
      users: users
      isEditing: false
      name: ''
      age: ''
    )

  render: ->
    list_users = []
    _this = this

    @state.users.forEach (user, index) ->
      {name, age} = user
      list_users.push(
        <tr key={index}>
          <td>{name}</td>
          <td>{age}</td>
          <td><a href='javascript:void(0)' onClick={_this.destroyUser.bind(_this, index)}>Destroy</a></td>
          <td><a href='javascript:void(0)' onClick={_this.editUser.bind(_this, index)}>Edit</a></td>
        </tr>
      )

    <div>
      <h1>Panel Users</h1>
      <div>
        <p>
          Name :
          <input type="text" value={@state.name} onChange={@onNameChanged}/>
        </p>
        <p>
          Price :
          <input type="text" value={@state.age} onChange={@onAgeChanged}/>
        </p>
        <p>
          {!this.state.isEditing && <button id='insertButton' onClick={this.insertUser}>Insert</button>}
          {this.state.isEditing && <button id='updateButton' onClick={this.updateUser}>Update</button>}
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
          {list_users}
         </tbody>
      </table>
    </div>