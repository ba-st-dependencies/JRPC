Extension { #name : #OrderedDictionary }

{ #category : #'*JRPC-GS64-Extensions' }
OrderedDictionary >> stonOn: stonWriter [
	"I store my instances as maps. When in JSON mode,
	encode me directly, without a class tag, keeping the order."

	stonWriter jsonMode
		ifTrue: [
			stonWriter encodeMap: self ]
		ifFalse: [
			stonWriter
				writeObject: self
				do: [ stonWriter encodeMap: self ] ]
]
