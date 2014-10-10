`import Ember from 'ember'`

AuthenticatedRoute = Ember.Route.extend

  beforeModel: (transition) ->
    alert('Authenticated Route')
    unless @controllerFor('application').isAuthenticated()
      @transitionTo("sessions.login")
      return


`export default AuthenticatedRoute`
