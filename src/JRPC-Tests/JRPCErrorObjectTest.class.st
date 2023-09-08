Class {
	#name : #JRPCErrorObjectTest,
	#superclass : #TestCase,
	#category : #'JRPC-Tests'
}

{ #category : #tests }
JRPCErrorObjectTest >> testAsJRPCJSON [

	| dict |

	dict := JRPCErrorObject internalError asJRPCJSON.

	self assertCollection: dict keys hasSameElements: #( 'code' 'message' ).
	self assert: ( dict at: 'code' ) equals: JRPCConstants internalErrorCode.
	self
		assert: ( dict at: 'message' )
		equals: ( JRPCConstants descriptionFor: JRPCConstants internalErrorCode ).

	dict := ( JRPCErrorObject
		          code: 0
		          message: 'Error for testing'
		          data: { ( 'help' -> 'Do not panic, this is just for test.' ) } asDictionary ) asJRPCJSON.

	self assertCollection: dict keys hasSameElements: #( 'code' 'message' 'data' ).
	self assert: ( dict at: 'code' ) equals: 0.
	self assert: ( dict at: 'message' ) equals: 'Error for testing'.
	self assertCollection: ( dict at: 'data' ) keys hasSameElements: #( 'help' ).
	self assert: ( ( dict at: 'data' ) at: 'help' ) equals: 'Do not panic, this is just for test.'
]

{ #category : #tests }
JRPCErrorObjectTest >> testInstanceCreationInternalError [

	| instance |

	instance := JRPCErrorObject internalError.

	self assert: instance code equals: JRPCConstants internalErrorCode.
	self
		assert: instance message
		equals: ( JRPCConstants descriptionFor: JRPCConstants internalErrorCode ).
	self assert: instance data isNil
]

{ #category : #tests }
JRPCErrorObjectTest >> testInstanceCreationInvalidParams [

	| instance |

	instance := JRPCErrorObject invalidParams.

	self assert: instance code equals: JRPCConstants invalidParametersErrorCode.
	self
		assert: instance message
		equals: ( JRPCConstants descriptionFor: JRPCConstants invalidParametersErrorCode ).
	self assert: instance data isNil
]

{ #category : #tests }
JRPCErrorObjectTest >> testInstanceCreationInvalidRequest [

	| instance |

	instance := JRPCErrorObject invalidRequest.

	self assert: instance code equals: JRPCConstants invalidRequestErrorCode.
	self
		assert: instance message
		equals: ( JRPCConstants descriptionFor: JRPCConstants invalidRequestErrorCode ).
	self assert: instance data isNil
]

{ #category : #tests }
JRPCErrorObjectTest >> testInstanceCreationMethodNotFound [

	| instance |

	instance := JRPCErrorObject methodNotFound.

	self assert: instance code equals: JRPCConstants methodNotFoundErrorCode.
	self
		assert: instance message
		equals: ( JRPCConstants descriptionFor: JRPCConstants methodNotFoundErrorCode ).
	self assert: instance data isNil
]

{ #category : #tests }
JRPCErrorObjectTest >> testInstanceCreationParseError [

	| instance |

	instance := JRPCErrorObject parseError.

	self assert: instance code equals: JRPCConstants parseErrorCode.
	self
		assert: instance message
		equals: ( JRPCConstants descriptionFor: JRPCConstants parseErrorCode ).
	self assert: instance data isNil
]
