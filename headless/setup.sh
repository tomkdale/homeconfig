#!/bin/bash

if [ $# -ne 2 ]; then
				echo " Please pass in username and machine ip as arguments"
				exit 1
fi

scp .??* $1@$2:~/ 

