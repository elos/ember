`import DS from 'ember-data'`

User = DS.Model.extend
  name: DS.attr()

  createdAt: DS.attr('date')

  events: DS.hasMany('event')


`export default User`
