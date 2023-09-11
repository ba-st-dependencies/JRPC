Extension { #name : #Error }

{ #category : #'*JRPC-Extensions' }
Error >> asJRPCJSON [

	^ {
		  'errorClass' -> self class name asString.
		  'messageText'
		   -> (self messageText ifNotNil: [ :message | message asString ]).
		  'tag' -> (self tag ifNotNil: [ :object | object asString ]) }
		  asDictionary
]

{ #category : #'*JRPC-Extensions' }
Error >> asJRPCResponse [
	^ self asJRPCResponseWithId: nil
]

{ #category : #'*JRPC-Extensions' }
Error >> asJRPCResponseWithId: anInteger [
	| response |
	response := JRPCErrorResponseObject id: anInteger error: JRPCErrorObject internalError.
	response error
		data: self asJRPCJSON.
	^ response
]
