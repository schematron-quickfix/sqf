# Merge sl

The use case is that in DITA it can easily happen to have two consecutive sl elements which might look identical in the author mode of oXygen XML editor. But in publication the spacing might be differently. 

The quick fix will merge all the content of the second sl element into the previous one.

## Issue
Currently there is one issue: The attribute defaults will be resolved within the merged content. This is usually not desired.