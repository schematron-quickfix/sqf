# Outsource DITA Topic

The idea is that schematron checks if there is any child topic within the same file. A quick fix can outsource all child topics and modify the DITA map as well.

Identifying the DITA map that needs to be modified, works by searching for any *.ditamap file within the same folder that references the topic. 

The file oursource-dita-topics-dita-semia.dita required the dita-semia plugin (https://github.com/dita-semia/dita-semia-resolver) to be installed for proper rendering in oXygen. The file has been created to demonstrate a more complicated use-case for handling attribute defaults.