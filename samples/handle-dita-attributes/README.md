# Handle DITA attributes

DITA makes a lot use of attributes with default values. One use case is to set static properties in the schema (e.g. @class and @domains). Another is to set a real default value that can be changed by the author.

The difficulty is that on the one hand you might want to use these attribute defaults (especially @class) to identify specific nodes. On the other hand you usually don't want to have such attributes added to the result document when they where not explicitly set in the original document.

This sample is to demonstrate different ways how to handle such attribute defaults.