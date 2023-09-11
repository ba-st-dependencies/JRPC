Extension { #name : #STONReaderError }

{ #category : #'*JRPC-STON-Extensions' }
STONReaderError >> asJRPCResponse [
	^ JRPCErrorResponseObject id: nil error: JRPCErrorObject parseError
]
