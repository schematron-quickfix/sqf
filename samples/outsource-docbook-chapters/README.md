# Outsource DocBook Chapters

The idea is that schematron checks if all chapter elements within the book should have their own file and be referenced with xinclude. A quick fix can outsource the chapters.

Since in oXygen it is currently not possible to generate xinclude elements there are two quick fixes offered: One that tries to generate real xincludes and another one that generates faked xincludes to see the result in oXygen as well. 