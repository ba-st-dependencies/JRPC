"
I am a shared pool holding constants defined by JSON-RPC 2.0 spec [1].

[1]: https://www.jsonrpc.org/specification
"
Class {
	#name : #JRPCConstants,
	#superclass : #Object,
	#classVars : [
		'DescriptionByErrorCode'
	],
	#category : #'JRPC-Common-Core'
}

{ #category : #accessing }
JRPCConstants class >> descriptionFor: errorCode [

	^ DescriptionByErrorCode at: errorCode
]

{ #category : #'class initialization' }
JRPCConstants class >> initialize [

	<ignoreForCoverage>
	DescriptionByErrorCode := Dictionary new.
	DescriptionByErrorCode
		at: self parseErrorCode put: 'Invalid JSON was received by the server.';
		at: self invalidRequestErrorCode put: 'The JSON sent is not a valid Request object.';
		at: self methodNotFoundErrorCode put: 'The method does not exist / is not available.';
		at: self invalidParametersErrorCode put: 'Invalid method parameter(s).';
		at: self internalErrorCode put: 'Internal JSON-RPC error.'
]

{ #category : #accessing }
JRPCConstants class >> internalErrorCode [

	^ -32603
]

{ #category : #accessing }
JRPCConstants class >> invalidParametersErrorCode [

	^ -32602
]

{ #category : #accessing }
JRPCConstants class >> invalidRequestErrorCode [

	^ -32600
]

{ #category : #accessing }
JRPCConstants class >> methodNotFoundErrorCode [

	^ -32601
]

{ #category : #accessing }
JRPCConstants class >> parseErrorCode [

	^ -32700
]

{ #category : #accessing }
JRPCConstants class >> version [

	^ '2.0'
]
