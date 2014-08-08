`import Ember from 'ember'`

Router = Ember.Router.extend
  location: ElosENV.locationType

Router.map ->
  @resource 'sessions', ->
    @route 'login'

`export default Router`
