@UsersPage = React.createClass
  getInitialState: ->
    console.log('initial state')
    {
      users: []
      isEditing: false
      formUser: { name: null, age: null }
    }

  componentDidMount: ->
    @setState({ users: [{name: 'a', age: 2}] })

  render: ->
    { users, formUser, isEditing } = @state
    list_users = []

    users.forEach (user, index) =>
      {name, age} = user
      list_users.push(
        <tr key={index}>
          <td>{name}</td>
          <td>{age}</td>
          <td><a href='javascript:void(0)' onClick={@destroyUser.bind(@, index)}>Destroy</a></td>
          <td><a href='javascript:void(0)' onClick={@editUser.bind(@, index)}>Edit</a></td>
        </tr>
      )

    <div>
      <h1>Panel Users</h1>
      <div>
        <p>
          Name :
          <input type="text" value={formUser.name} onChange={@onNameChanged}/>
        </p>
        <p>
          Price :
          <input type="text" value={formUser.age} onChange={@onAgeChanged}/>
        </p>
        <p>
          {!isEditing && <button id='insertButton' onClick={@insertUser}>Insert</button>}
          {isEditing && <button id='updateButton' onClick={@updateUser}>Update</button>}
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

  onNameChanged: (event)->
    { formUser } = @state
    formUser.name = event.target.value
    @setState(formUser: formUser)

  onAgeChanged: (event)->
    { formUser } = @state
    formUser.age = event.target.value
    @setState(formUser: formUser)

  insertUser: ->
    { users, formUser } = @state

    @setState
      users: users.concat(formUser)
      formUser: { name: null, age: null }

  destroyUser: (index) ->
    { users } = @state
    users.splice(index, 1)
    @setState(users: users)

  editUser: (index) ->
    { users } = @state
    user = users[index]

    @setState
      index: index
      formUser: user
      isEditing: true

  updateUser: ->
    { users, index, formUser } = @state

    users[index] = formUser

    @setState
      index: null
      users: users
      isEditing: false
      formUser: { name: null, age: null }
