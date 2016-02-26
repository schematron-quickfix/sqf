# Outsource DITA Topic

The idea is that schematron checks if there is any child topic within the same file. A quick fix can outsource all child topics and modify the DITA map as well.

Identifying the DITA map do modify works by searching for any *.ditamap file within the same folder that references the topic. 