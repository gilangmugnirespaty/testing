{createClass, PropTypes} = React
@TableCekson1Row = createClass
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
      <td><a href='javascript:void(0)' onClick={onEdit}>Editz</a></td>
      <td><a href='javascript:void(0)' onClick={onDestroy}>Delete</a></td>
    </tr>