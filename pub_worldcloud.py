import sys
import numpy as np
import pandas as pd
from os import path
from PIL import Image
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator

import stop_words
import matplotlib.pyplot as plt


def main(argv):
  """ Generates a word cloud based on a text file
  Parameters=max_font_size=40|max_words=80|background_color="rgba(255, 255, 255, 0)"|mode="RGBA"|source_file=input.txt|dest_file=mycloud.png|language=en|filter=[]"""

  pmax_font_size=80
  pmax_words=150
  pbackground_color="RGBA(0,0,0,0)"
  pmode="RGBA"
  source_file=r"/home/maxm/ESLauncher/output.txt"
  dest_file=r"/home/maxm/ESLauncher/output.png"
  planguage='en'
  pfilter =['coronavirus']
  
  # Parse all arguments except the first argument (which is the script filename)

  for item in argv[1:]:
    apos = item.find('=')
    avalue = item[apos+1:]


    if 'max_font_size=' in item:
      pmax_font_size = int(avalue)

    if 'max_words=' in item:
      pmax_words = int(avalue)

    if 'background_color=' in item:
      pbackground_color = avalue      

    if 'mode=' in item:
      pmode = avalue  

    if 'language=' in item:
      planguage = avalue  

    if 'source_file=' in item:
      source_file = avalue  
    if 'dest_file=' in item:
      dest_file = avalue  

    if 'filter=' in item:
      pfilter = avalue[1:-1].split(',')

  file_content=open(source_file).read()

  if planguage !='':
    fstopwords=stop_words.get_stop_words(planguage)+pfilter
   
    
  else:
    fstopwords = set(STOPWORDS)


  # Create and generate a word cloud image: 
  wordcloud = WordCloud(width=800, height=600,stopwords=fstopwords,max_font_size=pmax_font_size,min_font_size=5,max_words=pmax_words,background_color=pbackground_color, mode=pmode).generate(file_content)
  wordcloud.to_file(dest_file)

  # Display the generated image:
  plt.imshow(wordcloud, interpolation='bilinear')
  plt.axis("off")
  #plt.show()
  
  


  

  
if __name__ == "__main__":
  main(sys.argv)