extends "res://scripts/bag_aware.gd"

var thread = Thread.new()

func get(api, resource, calling_object = null, callbacks = {}, expect_json = true):
    self._start_request_thread("GET", api, resource, "", calling_object,callbacks, expect_json)

func post(api, resource, data = "", calling_object = null, callbacks = {}, expect_json = true):
    self._start_request_thread("POST", api, resource, data, calling_object, callbacks, expect_json)

func _start_request_thread(method, api, resource, data = "", calling_object = null, callbacks = {}, expect_json = true):
    if self.thread.is_active():
        return

    var request_params = {
        'method' : method,
        'api' : api,
        'resource' : resource,
        'data' : data,
        'calling_object' : calling_object,
        'callbacks' : callbacks,
        'expect_json' : expect_json
    }

    self.thread.start(self, '_make_request', request_params)

func _make_request(parameters):
    var method = parameters['method']
    var api = parameters['api']
    var resource = parameters['resource']
    var data = parameters['data']
    var expect_json = parameters['expect_json']
    var response = {}

    if method == "GET":
        response = self.bag.online_request.get(api, resource, expect_json)
    elif method == "POST":
        response = self.bag.online_request.post(api, resource, data, expect_json)
    else:
        response = {
            'status' : "error",
            'response_code' : 0,
            'data' : {},
            'message' : "Unsupported method: " + method
        }

    parameters['response'] = response

    call_deferred("_execute_callback")

    return parameters

func _execute_callback():
    var parameters = self.thread.wait_to_finish()
    var calling_object = parameters['calling_object']
    var callbacks = parameters['callbacks']
    var response = parameters['response']

    if calling_object != null:
        if response.has('response_code') and callbacks.has("handle_" + str(response['response_code'])):
            calling_object.call(callbacks["handle_" + str(response['response_code'])], response)
        else:
            calling_object.call(callbacks["handle_error"], response)
