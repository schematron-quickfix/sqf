# Handle DocBook XIncludes

DocBook uses XInclude to split a larger document in separate files. 

The difficulty is that on the one hand you might want to apply the Schematron rules and the Quick Fixes to the included content as well. On the other hand you usually don't want to have these xIncludes being resolved after applying a quick fix.

This sample is to demonstrate different ways how to handle this situation.

NOTE: With oXygen 17.1 only the first QuickFix is currently working!?
  