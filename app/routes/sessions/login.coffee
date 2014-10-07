`import Ember from 'ember'`

LoginRoute = Ember.Route.extend
  actions:
    authenticate: ->
      adapter = @get('container').lookup "adapter:application"
      adapter.setProperties({"id": "5433a54397c1f90746000001", "key": "w2ah7X3Riu0sUYyh2TNVTPg7bB7Y_n7v0QlOpy0Ofj_3x0Z22U45Rb7CXnVQBNUr"})

`export default LoginRoute`
