`import Ember from 'ember'`

ApplicationController = Ember.Controller.extend

  adapter: null

  init: () ->
    @_super()
    @set('adapter', @get('container').lookup("adapter:application"))

  isAuthenticated: (->
    return @get('adapter').get('connected')
  ).property('adapter.connected')


`export default ApplicationController`


