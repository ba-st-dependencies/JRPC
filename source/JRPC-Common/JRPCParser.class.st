"
Utility to parse JSON-RPC messages and convert model objects to JSON.
"
Class {
	#name : #JRPCParser,
	#superclass : #Object,
	#category : #'JRPC-Common-Core'
}

{ #category : #converting }
JRPCParser >> convertJRPCJsonableObjectToJSON: aJRPCJsonableObject [

	^ String streamContents: [ :stream |
		  self convertJRPCJsonableObjectToJSON: aJRPCJsonableObject on: stream ]
]

{ #category : #converting }
JRPCParser >> convertJRPCJsonableObjectToJSON: aJRPCJsonableObject on: aStream [

	STONJSON put: aJRPCJsonableObject onStream: aStream
]

{ #category : #parsing }
JRPCParser >> parseSupposedJRPCMessageObjectFromStream: aStream forClient: aBoolean [
	"Try to parse a JRPCDictionaryObject that should be held by aStream
	 (but we're not sure at this point).
	 Generate understandable errors if there is a problem."

	| jsonObject |

	jsonObject := STONJSON fromStream: aStream.
	^ ( JRPCMessageObject classToInstantiateForJSONObject: jsonObject forClient: aBoolean )
		  fromJRPCJSONObject: jsonObject
]

{ #category : #parsing }
JRPCParser >> parseSupposedJRPCMessageObjectFromString: aString forClient: aBoolean [

	| readStream |

	readStream := aString readStream.
	^ [ self parseSupposedJRPCMessageObjectFromStream: readStream forClient: aBoolean ] ensure: [
		  readStream close ]
]
