"
I am an abstract handler that deal with JRPC request for the #methodName I have.

I define the common API expected from any handler.

My concrete subclasses must override #executeWithArguments: method to define what they do and #parametersNames returns the name of the parameters I expect.

I also know the #server to which I have been added (if any).
"
Class {
	#name : #JRPCAbstractHandler,
	#superclass : #Object,
	#instVars : [
		'methodName',
		'isForNotification',
		'isForRequest'
	],
	#category : #'JRPC-Server-Core'
}

{ #category : #accessing }
JRPCAbstractHandler class >> defaultMethodName [
	"Returns the method name that will be set to the handler instance by default."
	^ self subclassResponsibility
]

{ #category : #comparing }
JRPCAbstractHandler >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self methodName = anObject methodName
		and: [ self isForNotification = anObject isForNotification
			and: [ self isForRequest = anObject isForRequest ] ]
]

{ #category : #testing }
JRPCAbstractHandler >> canHandle: aRequestOrNotification [
	^ (self isForRequest and: [ aRequestOrNotification isRequest ])
		or: [ self isForNotification and: [ aRequestOrNotification isNotification ] ]
]

{ #category : #accessing }
JRPCAbstractHandler >> defaultMethodName [
	^ self class defaultMethodName
]

{ #category : #evaluation }
JRPCAbstractHandler >> executeWithArguments: anArrayOrDictionary [
	^ self subclassResponsibility
]

{ #category : #comparing }
JRPCAbstractHandler >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ self isForNotification hash
		bitXor: (self isForRequest hash bitXor: self methodName hash)
]

{ #category : #initialization }
JRPCAbstractHandler >> initialize [
	super initialize.
	self isForRequest: true.
	self isForNotification: true
]

{ #category : #accessing }
JRPCAbstractHandler >> isForNotification [
	^ isForNotification
]

{ #category : #accessing }
JRPCAbstractHandler >> isForNotification: aBoolean [
	(aBoolean not and: [ self isForRequest not ])
		ifTrue: [ self error: 'A handler must be for notification or for request. It can not refuse both!' ].
		
	isForNotification := aBoolean
]

{ #category : #accessing }
JRPCAbstractHandler >> isForRequest [
	^ isForRequest
]

{ #category : #accessing }
JRPCAbstractHandler >> isForRequest: aBoolean [
	(aBoolean not and: [ self isForNotification not ])
		ifTrue: [ self error: 'A handler must be for notification or for request. It can not refuse both!' ].
	
	isForRequest := aBoolean
]

{ #category : #accessing }
JRPCAbstractHandler >> methodName [
	^ methodName ifNil: [ methodName := self defaultMethodName ]
]

{ #category : #accessing }
JRPCAbstractHandler >> methodName: anObject [
	methodName := anObject asString
]
