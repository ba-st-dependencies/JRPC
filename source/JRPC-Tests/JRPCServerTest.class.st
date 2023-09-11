Class {
	#name : #JRPCServerTest,
	#superclass : #TestCase,
	#instVars : [
		'server'
	],
	#category : #'JRPC-Tests'
}

{ #category : #test }
JRPCServerTest >> messageProcessor [

	^ server messageProcessor
]

{ #category : #running }
JRPCServerTest >> setUp [
	super setUp.
	server := JRPCServer new.
	
	server
		addHandlerNamed: 'setUpHandler' block: [ 42 ]
]

{ #category : #test }
JRPCServerTest >> testAddHandler [

	| handler |

	self
		assert: self messageProcessor handlersCount equals: 1;
		should: [ self messageProcessor handlersDetect: [ :h | h methodName = 'mock' ] ] raise: NotFound.

	handler := JRPCMockHandler new.
	server addHandler: handler.

	self
		assert: self messageProcessor handlersCount equals: 2;
		shouldnt: [ self messageProcessor handlersDetect: [ :h | h methodName = 'mock' ] ] raise: NotFound
]

{ #category : #test }
JRPCServerTest >> testAddHandlerDuplicated [

	| handler |

	handler := JRPCMockHandler new.
	server addHandler: handler.

	self
		should: [ server addHandler: handler ]
		raise: JRPCDuplicatedHandlerError
		withExceptionDo: [ :error | self assert: error handler equals: handler ]
]

{ #category : #tests }
JRPCServerTest >> testAddHandlerNamedBlock [

	| block |

	self assert: self messageProcessor handlersCount equals: 1.
	block := [ :x | x ].
	server addHandlerNamed: 'test' block: block.

	self assert: self messageProcessor handlersCount equals: 2.
	self shouldnt: [ self messageProcessor handlersDetect: [ :h | h methodName = 'test' ] ] raise: NotFound.
]

{ #category : #tests }
JRPCServerTest >> testAddHandlerNamedWithArgumentsBlock [

	| block request response |
	self assert: self messageProcessor handlersCount equals: 1.
	block := [ :x :y | x + y ].
	server
		addHandlerNamed: 'sum'
		withArgumentsNamed: #( x y )
		evaluating: block.

	request := JRPCRequestObject id: 1 method: 'sum' params: #( 3 4 ).
	response := server handleJRPCRequestObject: request.

	self
		deny: response isError;
		assert: response result equals: 7.

	request := JRPCRequestObject id: 1 method: 'sum' params: {
			           #y -> 4.
			           #x -> 3 } asDictionary.
	response := server handleJRPCRequestObject: request.

	self
		deny: response isError;
		assert: response result equals: 7
]

{ #category : #test }
JRPCServerTest >> testAddHandlersFromPragmasIn [

	| exampleStack |

	self assert: self messageProcessor handlersCount equals: 1.

	exampleStack := JRPCExampleStack new.
	server addHandlersFromPragmasIn: exampleStack.

	self
		assert: self messageProcessor handlersCount equals: 4;
		shouldnt: [ self messageProcessor handlersDetect: [ :h | h methodName = 'stack_top' ] ] raise: NotFound;
		shouldnt: [ self messageProcessor handlersDetect: [ :h | h methodName = 'stack_pop' ] ] raise: NotFound;
		shouldnt: [ self messageProcessor handlersDetect: [ :h | h methodName = 'stack_push' ] ] raise: NotFound
]

{ #category : #test }
JRPCServerTest >> testDebugMode [
	self deny: server debugMode.
	self deny: server messageProcessor debugMode.
	
	server debugMode: true.
	
	self assert: server debugMode.
	self assert: server messageProcessor debugMode
]

{ #category : #tests }
JRPCServerTest >> testErrorHandling [

	| requestForInternalError errorWasRaised response |

	errorWasRaised := false.

	server
		addHandlerNamed: 'divide' block: [ :x :y | x / y ];
		addErrorHandler: [:error | errorWasRaised := true].

	requestForInternalError := JRPCRequestObject id: 1 method: 'divide' params: #(1 0).
	
	response := server handleJRPCRequestObject: requestForInternalError.

	self
		assert: response isError;
		assert: errorWasRaised
]

{ #category : #tests }
JRPCServerTest >> testHandleJRPCRequestObject [
	| requestForNonExistentHandler response |
	requestForNonExistentHandler := JRPCRequestObject id: 1 method: 'setUpHandler'.
	
	response := server handleJRPCRequestObject: requestForNonExistentHandler.
	
	self assert: response class equals: JRPCSuccessResponseObject.
	self assert: response result equals: 42.
]

{ #category : #tests }
JRPCServerTest >> testHandleJRPCRequestObject2 [
	| requestForNonExistentHandler response |
	requestForNonExistentHandler := JRPCRequestObject id: 1 method: 'setUpHandler' params: #().
	
	response := server handleJRPCRequestObject: requestForNonExistentHandler.
	
	self assert: response class equals: JRPCSuccessResponseObject.
	self assert: response result equals: 42.
]

{ #category : #tests }
JRPCServerTest >> testHandleJRPCRequestObject3 [
	| requestForNonExistentHandler response |
	requestForNonExistentHandler := JRPCRequestObject id: 1 method: 'setUpHandler' params: Dictionary new.
	
	response := server handleJRPCRequestObject: requestForNonExistentHandler.
	
	self assert: response class equals: JRPCSuccessResponseObject.
	self assert: response result equals: 42.
]

{ #category : #tests }
JRPCServerTest >> testHandleJRPCRequestObjectInvalidParams [

	| requestForNonExistentHandler response |

	requestForNonExistentHandler := JRPCRequestObject
		                                id: 1
		                                method: 'setUpHandler'
		                                params: { ( #x -> 1 ) } asDictionary.

	response := server handleJRPCRequestObject: requestForNonExistentHandler.

	self assert: response class equals: JRPCErrorResponseObject.
	self assert: response error code equals: JRPCConstants invalidParametersErrorCode.
	self
		assert: response error message
		equals: ( JRPCConstants descriptionFor: JRPCConstants invalidParametersErrorCode ).
	self assert: response error data isNil
]

{ #category : #tests }
JRPCServerTest >> testHandleJRPCRequestObjectInvalidParams2 [

	| requestForNonExistentHandler response |

	requestForNonExistentHandler := JRPCRequestObject id: 1 method: 'setUpHandler' params: #( 1 2 ).

	response := server handleJRPCRequestObject: requestForNonExistentHandler.

	self assert: response class equals: JRPCErrorResponseObject.
	self assert: response error code equals: JRPCConstants invalidParametersErrorCode.
	self
		assert: response error message
		equals: ( JRPCConstants descriptionFor: JRPCConstants invalidParametersErrorCode ).
	self assert: response error data isNil
]

{ #category : #tests }
JRPCServerTest >> testHandleJRPCRequestObjectInvalidParams3 [

	| requestForNonExistentHandler response |

	server addHandlerNamed: '2params' block: [ :x :y | x + y ].
	requestForNonExistentHandler := JRPCRequestObject id: 1 method: '2params' params: #( 1 ).

	response := server handleJRPCRequestObject: requestForNonExistentHandler.

	self assert: response class equals: JRPCErrorResponseObject.
	self assert: response error code equals: JRPCConstants invalidParametersErrorCode.
	self
		assert: response error message
		equals: ( JRPCConstants descriptionFor: JRPCConstants invalidParametersErrorCode ).
	self assert: response error data isNil
]

{ #category : #tests }
JRPCServerTest >> testHandleJRPCRequestObjectInvalidParams4 [

	| requestForNonExistentHandler response |

	server addHandlerNamed: '2params' block: [ :x :y | x + y ].
	requestForNonExistentHandler := JRPCRequestObject id: 1 method: '2params' params: #( 1 2 3 ).

	response := server handleJRPCRequestObject: requestForNonExistentHandler.

	self assert: response class equals: JRPCErrorResponseObject.
	self assert: response error code equals: JRPCConstants invalidParametersErrorCode.
	self
		assert: response error message
		equals: ( JRPCConstants descriptionFor: JRPCConstants invalidParametersErrorCode ).
	self assert: response error data isNil
]

{ #category : #tests }
JRPCServerTest >> testHandleJRPCRequestObjectInvalidParams5 [

	| requestForNonExistentHandler response |

	server addHandlerNamed: '2params' block: [ :x :y | x + y ].
	requestForNonExistentHandler := JRPCRequestObject id: 1 method: '2params'.

	response := server handleJRPCRequestObject: requestForNonExistentHandler.

	self assert: response class equals: JRPCErrorResponseObject.
	self assert: response error code equals: JRPCConstants invalidParametersErrorCode.
	self
		assert: response error message
		equals: ( JRPCConstants descriptionFor: JRPCConstants invalidParametersErrorCode ).
	self assert: response error data isNil
]

{ #category : #tests }
JRPCServerTest >> testHandleJRPCRequestObjectNonExistent [

	| requestForNonExistentHandler response |

	requestForNonExistentHandler := JRPCRequestObject id: 1 method: 'nonExistent'.

	response := server handleJRPCRequestObject: requestForNonExistentHandler.

	self assert: response class equals: JRPCErrorResponseObject.
	self assert: response error code equals: JRPCConstants methodNotFoundErrorCode.
	self
		assert: response error message
		equals: ( JRPCConstants descriptionFor: JRPCConstants methodNotFoundErrorCode ).
	self assert: response error data isNil
]

{ #category : #tests }
JRPCServerTest >> testHandleJSON [
	| jsonResponse |
	jsonResponse := server handleJSON: '{"jsonrpc" : "2.0", "id" : 41, "method" : "setUpHandler"}'.
	
	self assert: jsonResponse equals: '{"jsonrpc":"2.0","result":42,"id":41}'.
	
	jsonResponse := server handleJSON: '{'.
	
	self assert: jsonResponse equals: '{"jsonrpc":"2.0","id":null,"error":{"code":-32700,"message":"Invalid JSON was received by the server."}}'
]

{ #category : #tests }
JRPCServerTest >> testInternalError [

	| requestForInternalError response data |
	server addHandlerNamed: 'divide' block: [ :x :y |
		y isZero ifTrue: [
			ZeroDivide new
				messageText: 'Division by zero';
				tag: x;
				signal ].
		x / y ].

	requestForInternalError := JRPCRequestObject
		                           id: 1
		                           method: 'divide'
		                           params: #( 1 0 ).

	response := server handleJRPCRequestObject: requestForInternalError.

	self assert: response class equals: JRPCErrorResponseObject.
	self
		assert: response error code
		equals: JRPCConstants internalErrorCode.
	self
		assert: response error message
		equals:
		(JRPCConstants descriptionFor: JRPCConstants internalErrorCode).
	self assert: response error data isNotNil.

	data := response error data.
	self assertCollection: data equals: {
			'errorClass' -> 'ZeroDivide'.
			'messageText' -> 'Division by zero'.
			'tag' -> '1' } asDictionary
]
