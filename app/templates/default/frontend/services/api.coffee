#
# Based heavily on 
# https://gist.github.com/jelbourn/6276338 by Jeremy Elbourn (@helbourn)
#
# @author Henrique Pinheiro (@phenome)

# Namespace for the application
jelbourn = {}
# Interface for a model objects used with the api service.
# @mixin
# @method #afterLoad 
#   Data transformation done after fetching data from the server.
# @method #beforeSave
#   Data transformation done before posting / putting data to the server.
jelbourn.ApiModel

# Configuration object for an api endpoint.
class jelbourn.ApiEndpointConfig
  # @property [Object]  Map of actions for the endpoint, keyed by action name. 
  #    An action has a HTTP method (GET, POST, etc.) as well as an optional set of default parameters.
  actions: {}
  # The Constructor
  constructor : ->
    @actions = {}
    defaultActions =
      'get'     :'GET'
      'update'  :'PUT'   
      'save'    :'POST'  
      'patch'   :'PATCH' 
      'remove'  :'DELETE'
      'query'   :['GET']
    angular.forEach defaultActions, (method, alias) =>
      if angular.isArray method
        @addHttpAction method[0], alias, {}, true
      else
        @addHttpAction method, alias
  # Set the route for this endpoint. This is relative to the server's base route.
  # @param {string} route.
  # @return {jelbourn.ApiEndpointConfig}
  route : (@route) -> @
  # Set the route for this endpoint. This is relative to the server's base route.
  # @param {function(): jelbourn.ApiModel} model
  # @return {jelbourn.ApiEndpointConfig}
  model : (@model) -> @
  # Adds an action to the endpoint.
  # @param {string} method The HTTP method for the action.
  # @param {string} name The name of the action.
  # @param {Object=} params The default parameters for the action.
  # @param {Boolean} isArray If the method returns an array.
  addHttpAction : (method, name, params, isArray = false) ->
    @actions[name] = method:method.toUpperCase(), params:params, isArray:isArray
#  An api endpoint.
class jelbourn.ApiEndpoint
  # @param baseRoute {String} The server api's base route.
  # @param endpointConfig {jelbourn.ApiEndpointConfig} endpointConfig configuration object
  #   for the endpoint.
  # @param $injector {!Object} The angular $injector service.
  # @param $resource {!Function} The angular $resource service.
  constructor : (baseRoute, endpointConfig, @$injector, $resource) ->
    @config = endpointConfig
    @resource = $resource baseRoute + endpointConfig.route, {}, endpointConfig.actions
    angular.forEach endpointConfig.actions, (action, actionName) =>
      actionMethod = @request
      if endpointConfig.model
        if action.method is 'GET'
          actionMethod = @getRequestwithModel
        else if action.method is 'PUT' or action.method is 'POST'
          actionMethod = @saveRequestWithModel
      @[actionName] = angular.bind @, actionMethod, actionName
  # Instantiates a model object from the raw server response data.
  # @param {Object} data The raw server response data.
  # @return {jelbourn.ApiModel} The server response data wrapped in a model object.      
  instantiateModel : (data) ->
    model = @$injector.instantiate @config.model
    angular.extend model,data
    model.afterLoad()
    model
  # Perform a standard http request.
  #
  # @param {string} action The name of the action.
  # @param {Object=} params The parameters for the request.
  # @param {Object=} data The request data (for PUT / POST requests).
  # @return {angular.$q.Promise} A promise resolved when the http request has
  #   a response.
  request : (action, params, data) ->
    @resource[action](params,data,->).$promise
  # Perform an HTTP GET request and performs a post-response transformation
  # on the data as defined in the model object.
  # 
  # @param {string} action The name of the action.
  # @param {Object=} params The parameters for the request.
  # @return {angular.$q.Promise} A promise resolved when the http request has
  #   a response.
  getRequestwithModel : (action, params) ->
    promise = @request action, params
    instantiateModel = @instantiateModel.bind @
    promise.then (data) ->
      data = if angular.isArray data
        data.map instantiateModel
      else
        instantiateModel data
  # Performs an HTTP PUT or POST after performing a pre-request transformation
  # on the data as defined in the model object.
  # 
  # @param {string} action The name of the action.
  # @param {Object=} params The parameters for the request.
  # @param {Object=} data The request data (for PUT / POST requests).
  # @return {angular.$q.Promise} A promise resolved when the http request has
  #   a response.
  saveRequestWithModel : (action, params, data) ->
    if not data
      data = params
      params = {}
    model = angular.copy data
    model?.beforeSave?()
    @request action, params, model

# Angular provider for configuring and instantiating as api service.
class jelbourn.ApiProvider
  # The constructor
  constructor : ->
    @baseRoute = ''
    @endpoints = {}

  # @param baseRoute [String] The base server route
  setBaseRoute : (@baseRoute) ->
  # Creates an api endpoint. The endpoint is returned so that configuration of
  # the endpoint can be chained.
  # 
  # @param {string} name The name of the endpoint.
  # @return {jelbourn.ApiEndpointConfig} The endpoint configuration object.
  endpoint : (name) ->
    endpointConfig = new jelbourn.ApiEndpointConfig
    @endpoints[name] = endpointConfig
    endpointConfig
  # Function invoked by angular to get the instance of the api service.
  # @return {Object.<string, jelbourn.ApiEndpoint>} The set of all api endpoints.
  $get : ['$injector', ($injector) ->
    api = {}
    angular.forEach @endpoints, (endpointConfig, name) =>
      api[name] = $injector.instantiate jelbourn.ApiEndpoint,
        {@baseRoute,endpointConfig}
    api
  ]