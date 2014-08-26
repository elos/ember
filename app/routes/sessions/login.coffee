`import Ember from 'ember'`

LoginRoute = Ember.Route.extend
  model: ->
    @store.find 'session', 1

`export default LoginRoute`
