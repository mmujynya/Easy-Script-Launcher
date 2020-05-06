import pandas as pd
import sys



def main(argv):
  """ Extracts core tweet text from file produced by Tweeter Stream and stores it in a text file.
  Parameters=input_file=input.txt|output_file=output.txt"""

  input_file = r'C:\dev\ESL\input.txt'
  output_file = r'C:\dev\ESL\output.txt'

  # Parse all arguments except the first argument (which is the script filename)
  
  for item in argv[1:]:
    apos = item.find('=')
    avalue = item[apos+1:]

    if 'input_file=' in item:
      input_file = avalue      

    if 'output_file=' in item:
      output_file = avalue  

  data = pd.read_csv(input_file, sep='\^',engine='python',header=None)

  data[6].to_csv(output_file,index=False,header=False)

if __name__ == "__main__":
  main(sys.argv)

