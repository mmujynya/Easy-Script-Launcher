#!/usr/bin/env python3
# 
# Simple python script to illustrate how to start an Easy Script Launcher (ESL)  workbook for a python script
# 
# Requirements: import the "sys" package and have the "main" function use the parameters
# 
# To make the script more robust, it could be best to implement some argv processing where the script is
# given arguments in "key=value" format
# Examples of such implementations can be seen in some of the python scipts provided: emails.py etc.
#
# We don't implement this here. Instead, we map the "float" function to the list of parameters passed by ESL
#
#  Max Mujynya - 2020-04-30

import sys

def main(argv):
  """ Simple example script that sums 2 numbers given as arguments
  Parameters=number_1=x|number_2=y"""

  nb_arg=len(argv)-1 # argv[0] is always the name of the script, we are skipping it

  if nb_arg<2:
    print('**** TOO FEW ARGUMENTS: {} instead of at least 2 arguments'.format(nb_arg))
    print('     This script assumes that you passed at least 2 numbers as arguments')
    print('     Please add at least 2 arguments then try again')
  else:
    print('The first argument is: {} ... and the last one is: {}'.format(argv[1],argv[nb_arg]))
    print('The sum is: {}'.format(sum(map(float,argv[1:]))))



if __name__ == "__main__":
  main(sys.argv)
