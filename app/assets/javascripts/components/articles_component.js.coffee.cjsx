@ArticlesComponent = React.createClass
  getInitialState: ->
    {
      articles: []
      isEditing: false
      formArticle : {name: '', category: ''}
    }

  render: ->
    { formArticle, articles, isEditing } = @state
    list_articles = []
    console.log(articles)
    articles.forEach (article, index) =>
      {name, category} = article
      list_articles.push(
        <tr key={index}>
          <td>{name}</td>
          <td>{category}</td>
          <td><a href='javascript:void(0)' onClick={@destroyArticle.bind(@, index)}>Destroy</a></td>
          <td><a href='javascript:void(0)' onClick={@editArticle.bind(@, index)}>Edit</a></td>
        </tr>
      )

    <div>
      <h1>Panel Article</h1>
      <div>
        <p>
          Name :
          <input type="text" value={formArticle.name} onChange={@onNameChanged}/>
        </p>
        <p>
          Category :
          <input type="text" value={formArticle.category} onChange={@onCategoryChanged}/>
        </p>
        <p>
          {!isEditing && <button id='insertButton' onClick={@insertArticle}>Insert</button>}
          {isEditing && <button id='updateButton' onClick={@updateArticle}>Update</button>}
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
          {list_articles}
         </tbody>
      </table>
    </div>

  onNameChanged: (event)->
    {formArticle} = @state
    formArticle.name = event.target.value
    @setState formArticle: formArticle

  onCategoryChanged: (event)->
    {formArticle} = @state
    formArticle.category = event.target.value
    @setState formArticle: formArticle

  insertArticle: ->
    {formArticle, articles} = @state
    @setState(
      articles: articles.concat(formArticle)
      formArticle: {name: '', category: ''}
    )

  destroyArticle: (index) ->
    { articles } = @state
    articles.splice(index, 1)
    @setState(articles: articles)

  editArticle: (index) ->
    {isEditing, articles, formArticle} = @state
    article = articles[index]
    formArticle.name = article.name
    formArticle.category = article.category

    @setState
      index: index
      isEditing: true
      formArticle: formArticle

  updateArticle: ->
    {articles, index, formArticle} = @state
    articles[index] = formArticle

    @setState
      index: null
      formArticle: {name: '', category: ''}
      articles: articles
      isEditing: false
