Extension { #name : #STONReaderError }

{ #category : #'*JRPC-Extensions' }
STONReaderError >> asJRPCResponse [
	^ JRPCErrorResponseObject id: nil error: JRPCErrorObject parseError
]
