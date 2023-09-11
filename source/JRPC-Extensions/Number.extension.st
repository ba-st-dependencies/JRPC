Extension { #name : #Number }

{ #category : #'*JRPC-Extensions' }
Number >> asJRPCJSON [
	^ self asFloat
]
