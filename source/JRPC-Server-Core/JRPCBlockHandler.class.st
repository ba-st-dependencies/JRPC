"
I am a handler for which the execution is defined by my #block.

My #executeWithArguments: method just delegate the execution to my #block inst. var.
"
Class {
	#name : #JRPCBlockHandler,
	#superclass : #JRPCMessageSendHandler,
	#instVars : [
		'argumentNames'
	],
	#category : #'JRPC-Server-Core'
}

{ #category : #accessing }
JRPCBlockHandler class >> defaultMethodName [
	"If this method is called, it means that the user did not set the #methodName of the block handler.
	 It is mandatory to do it.
	"
	^ self error: 'It is mandatory to specify the #methodName of a block handler via #methodName: method on instance side.'
]

{ #category : #'instance creation' }
JRPCBlockHandler class >> methodName: methodName block: block [

	^ self
		  procedureName: methodName
		  block: block
		  argumentOrderDeterminedBy: block argumentNames
]

{ #category : #'instance creation' }
JRPCBlockHandler class >> procedureName: aString block: aBlock argumentOrderDeterminedBy: anArgumentNamesArray [

	^self new
		initializeProcedureName: aString
		block: aBlock
		argumentOrderDeterminedBy: anArgumentNamesArray
]

{ #category : #initialization }
JRPCBlockHandler >> initializeProcedureName: aProcedureName block: aBlock argumentOrderDeterminedBy: anArgumentNamesArray [

	self methodName: aProcedureName.
	self receiver: aBlock.
	self messageSelector: #valueWithArguments:.
	argumentNames := anArgumentNamesArray collect: #asString
]

{ #category : #accessing }
JRPCBlockHandler >> parametersNames [

	^ argumentNames
]

{ #category : #private }
JRPCBlockHandler >> send: aSelector to: aBlock with: arguments [
	^ super send: aSelector to: aBlock with: (Array with: arguments)
]
