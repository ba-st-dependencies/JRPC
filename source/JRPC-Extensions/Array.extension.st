Extension { #name : #Array }

{ #category : #'*JRPC-Extensions' }
Array >> asJRPCJSON [
	^ self collect: #asJRPCJSON
]
