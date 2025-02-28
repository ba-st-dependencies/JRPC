"
I am an abstract client for JSON-RPC 2.0.

My subclasses define how to transmit JSON-RPC objects to a server.

To define that, #sendRequest: message should be overriden by my subclasses.
"
Class {
	#name : #JRPCClient,
	#superclass : #Object,
	#instVars : [
		'parser'
	],
	#category : #'JRPC-Client-Core'
}

{ #category : #api }
JRPCClient >> callMethod: aString arguments: anObject withId: anInteger [
	"Call a method which takes arguments."
	^ self sendRequest: (JRPCRequestObject new
								id: anInteger;
								method: aString;
								params: anObject;
								yourself)
]

{ #category : #api }
JRPCClient >> callMethod: aString withId: anInteger [
	"Call a method which takes no arguments."
	^ self callMethod: aString arguments: nil withId: anInteger
]

{ #category : #converting }
JRPCClient >> convertJRPCJsonableObjectToJSON: aJRPCJsonableObject [

	^ parser convertJRPCJsonableObjectToJSON: aJRPCJsonableObject
]

{ #category : #initialization }
JRPCClient >> initialize [

	super initialize.
	parser := JRPCParser new
]

{ #category : #api }
JRPCClient >> notifyMethod: aString [ 
	self notifyMethod: aString arguments: nil
]

{ #category : #api }
JRPCClient >> notifyMethod: aString arguments: anArrayOrString [
	self sendNotification: (JRPCNotificationObject new
									method: aString;
									params: anArrayOrString;
									yourself)
]

{ #category : #'private - sending' }
JRPCClient >> sendNotification: aJRPCNotificationObject [
	"When a notification is sent to the server, we do not expect an answer."
	[ 
		self sendRequest: aJRPCNotificationObject
	] on: JRPCIncorrectJSON, STONReaderError do: [ "Does nothing on purpose." ]
]

{ #category : #'private - sending' }
JRPCClient >> sendRequest: aJRPCRequestObject [
	"To be implemented by concrete subclasses.
	 Sends aJRPCRequestObject to the server to which the client is connected.
	 Returns a JRPCSuccessResponseObject if everything goes well.
	 Returns a JRPCErrorResponse if something went wrong.
	"
	
	^ self subclassResponsibility
]
