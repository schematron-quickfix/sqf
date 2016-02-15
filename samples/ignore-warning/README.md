# Ignore Warning

This sample is to demonstrate how you can use quick fix to let the user mark some sections to ignore a specific warnings 
(just like Eclipse can do with Java warnings like 'unused local variable'). 

The idea is to use a special processing instruction which can be inserted anywhere within your document without limitations by the schema.
The schematron rule just has to ignore all content within an element that contains this specific processing instruction.
And the quick fix can add the processing instruction either within the current element, within the current topic or within the root document.