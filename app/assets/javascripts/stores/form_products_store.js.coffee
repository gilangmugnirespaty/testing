{ EventEmitter } = fbemitter

CHANGE_EVENT = 'form-products-store:change'

formNil = -> {name: '', price: ''}

window.FormProductsStore = _.assign(new EventEmitter(), {
  product: {}
})