`import Ember from 'ember'`

SessionsLoginController = Ember.ObjectController.extend
  credentials: null
  actions:
    authenticate: ->
      credentials = @get("credentials").split("-")
      id = credentials[0]
      key = credentials[1]
      adapter = @get('container').lookup "adapter:application"
      adapter.setProperties({"id": id, "key": key})

`export default SessionsLoginController`
