`import Ember from 'ember'`

SessionsLoginController = Ember.ObjectController.extend

  needs: ['application']

  credentials: null

  actions:
    authenticate: ->
      credentials = @get("credentials").split("-")
      id = credentials[0]
      key = credentials[1]
      @get('controllers.application.adapter').connect(id, key)

  authenticated: (()->
    if @get('controllers.application.adapter.connected')
      @transitionToRoute('home')
    else if @get('controllers.application.adapter.failedConnection')
      @loginFailed()
  ).observes('controllers.application.adapter.connected',
             'controllers.application.adapter.failedConnection')

  loginFailed: () ->
    alert('login failed :(')

 `export default SessionsLoginController`
