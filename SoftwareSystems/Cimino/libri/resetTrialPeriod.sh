#!/bin/bash

# Put the script in the installation folder of VisualParadigm and execute it.
# If it doesn't work remove the folder ~/.config/VisualParadigm

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE=$DIR/resources/product_edition.properties

if [ -f $FILE ]; then
	echo -e "edition=\nproduct=VP-UML" > $FILE
else
	echo "The script must be placed in the root folder of VisualParadigm installation."
fi