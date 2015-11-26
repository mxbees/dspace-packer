#!/bin/bash

sed ':a;N;$!ba;s/\n/ /g'

tr '\n' ' ' < input_filename
