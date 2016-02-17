# Register Key (Oxygen version)

The use case is that a specific key element is only allowed to contain values defined in a global key file.

The quick fix adds an unknown key to the global file.

This is an extension of the register-key sample with the addition that the global file also contains the author who registered the key.
The quick fix will add this from the configuration of the oXygen XML editor when being used in author mode.


## Special Preconditions
To make this sample work the following preconditions need to be met:

1. XSLT Processor
The processing of the XSLT code within the quick fix needs to be processed by Saxon EE

2. oXygen environment
The Schematorn check needs to be performed from oXygen.

3. External Java Library
The java library SqfOxyUtil.jar needs to be within the class path of Saxon. The file is placed in the folder samples/SqfOxyUtil/java. 

4. Configure Author
In the oXygen Options -> Editor -> Edit modes -> Author -> Review you need to enter your name (if not already done). 