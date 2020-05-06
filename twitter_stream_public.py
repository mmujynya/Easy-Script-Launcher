# Import package
import tweepy
import json
import sys
import re

non_bmp_map = dict.fromkeys(range(0x10000, sys.maxunicode + 1), 0xfffd)
filename = r"C;\i_coronavirus.txt"
pattern = re.compile('U000(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+')

# Modified Code from Hugo Bowne-Anderson - Data Scientist at DataCamp
class MyStreamListener(tweepy.StreamListener):
  def __init__(self, api=None,keywords_list=['coronavirus'],language_list=['en'],size=10,min_followers=0,exclude_retweets=False,destination=filename):
    super(MyStreamListener, self).__init__()
    self.num_tweets = 0
    self.file = open(destination, "w")
    self.language_list = language_list
    self.exclude_retweets = exclude_retweets
    self.size=size
    self.keywords_list = keywords_list

    self.min_followers = min_followers

  def on_status(self, status):

    tweet = status._json
    
    null = None

    truncated = tweet["truncated"]
    if truncated:
      atext = tweet["extended_tweet"]["full_text"].encode('unicode-escape').decode('utf-8')
    else:
      atext = tweet["text"].encode('unicode-escape').decode('utf-8')
    auser = tweet["user"]["name"].encode('unicode-escape').decode('utf-8')
    auserID = tweet["user"]["id_str"].encode('unicode-escape').decode('utf-8')
    auser_followers_count = tweet["user"]["followers_count"]
    retweeted = tweet["retweeted"]
    retweet_count = tweet["retweet_count"]
   

    auserLocation = tweet["user"]["location"]
    if auserLocation == None:
      auserLocation =""
    else:
      auserLocation =auserLocation.encode('unicode-escape').decode('utf-8')
      
    if len(atext)>2:
      # a bunch of silly replacements needed while extracting French tweets
      
      # atext = atext.replace('\\xe9','é')
      # atext = atext.replace('\\xc9','É')
      # atext = atext.replace('\\xe0','à')
      # atext = atext.replace('\\xc0','À')
      # atext = atext.replace('\\xe2','â')
      # atext = atext.replace('\\xc2','Â')      
      # atext = atext.replace('\\xf4','ô')
      # atext = atext.replace('\\xd4','Ô')
      # atext = atext.replace('\\xe8','è')
      # atext = atext.replace('\\xc8','È')
      # atext = atext.replace('\\xea','ê')
      # atext = atext.replace('\\xca','Ê')
      # atext = atext.replace('\\xe7','ç')
      # atext = atext.replace('\\xc7','Ç')
      # atext = atext.replace('\\xf9','ù')
      # atext = atext.replace('\\xd9','Ù')
      # atext = atext.replace('\\xfb','û')
      # atext = atext.replace('\\xdb','Û')


      atext = atext.replace('\\xe9','e')
      atext = atext.replace('\\xc9','E')
      atext = atext.replace('\\xe0','a')
      atext = atext.replace('\\xc0','A')
      atext = atext.replace('\\xe2','a')
      atext = atext.replace('\\xc2','A')      
      atext = atext.replace('\\xf4','o')
      atext = atext.replace('\\xd4','O')
      atext = atext.replace('\\xe8','e')
      atext = atext.replace('\\xc8','E')
      atext = atext.replace('\\xea','e')
      atext = atext.replace('\\xca','E')
      atext = atext.replace('\\xe7','c')
      atext = atext.replace('\\xc7','C')
      atext = atext.replace('\\xf9','u')
      atext = atext.replace('\\xd9','U')
      atext = atext.replace('\\xfb','u')
      atext = atext.replace('\\xdb','U')


      atext = atext.strip()
      atext = atext.replace('^','')
      atext = atext.replace('\\n','')
      atext = atext.replace('\\u2019',' ')
      atext = atext.replace('\\u2764',' ')
      atext = atext.replace('\\ufe0f',' ')
      atext = pattern.sub('', atext)
 
      aretweet = atext[0:2] == 'RT'


      auser=auser.replace('^','')
      auserLocation=auserLocation.replace('^','')

      if (tweet['lang'] in self.language_list) and (auser_followers_count>=self.min_followers):
        if not(aretweet and self.exclude_retweets):
          self.file.write( tweet['created_at']+ '^'+auserID+'^'+str(auser_followers_count)+'^'+str(aretweet)+'^'+str(retweeted)+'^'+str(retweet_count)+'^'+atext+'^'+auser+'^'+auserLocation+'\n')
          self.num_tweets += 1
          print(str(self.num_tweets)+'|'+atext)

    if self.num_tweets < self.size:
        return True
    else:
        return False
    self.file.close()

  def on_error(self, status):
    print(status)





def main(argv):
  """Filters Twitter stream using Tweepy and saves tweets in a text file using ^ as delimiter. This version doesn't include consumer and tokens. 
  Parameters=keywords_list=[coronavirus]|language_list=[en]|size=10|min_followers=10|exclude_retweets=False|destination=output.txt|access_token=1|access_token_secret=2|consumer_key=3|consumer_secret=4"""
  
  # Initialize Stream listener
  # api=None,keywords_list=['coronavirus'],language_list=['en'],size=10,min_followers=0,exclude_retweets=False,destination=filename
  def_size =10
  def_min_followers = 100
  def_keywords_list = ['lockdown']
  def_language_list = ['en']
  def_exclude_retweets = True
  def_destination = r"C:\i_coronavirus.txt"
  def_access_token = "get it from Twitter"
  def_access_token_secret ="get it from Twitter"
  def_consumer_key = "get it from Twitter"
  def_consumer_secret = "get it from Twitter"



  # Parse all arguments except the first argument (which is the script filename)
  for item in argv[1:]:
    apos = item.find('=')
    avalue = item[apos+1:]


    if 'size=' in item:
      def_size = int(avalue)

    elif 'keywords_list=' in item:
      def_keywords_list = avalue[1:-1].split(',')

    elif 'language_list=' in item:
      def_language_list = avalue[1:-1].split(',')    

    elif 'min_followers=' in item:
      def_min_followers = int(avalue)

    elif 'exclude_retweets=' in item:
      def_exclude_retweets = bool(avalue)      

    elif 'destination=' in item:
      def_destination = avalue      

    elif 'access_token=' in item:
      def_access_token = avalue  

    elif 'access_token_secret=' in item:
      def_access_token_secret = avalue  

    elif 'consumer_key=' in item:
      def_consumer_key = avalue 

    elif 'consumer_secret=' in item:
      def_consumer_secret = avalue

    else:
      pass


  # Pass OAuth details to tweepy's OAuth handler
  auth = tweepy.OAuthHandler(def_consumer_key, def_consumer_secret)
  auth.set_access_token(def_access_token,def_access_token_secret)

  l = MyStreamListener(size=def_size,min_followers=def_min_followers,keywords_list=def_keywords_list,
  language_list=def_language_list,exclude_retweets=def_exclude_retweets,destination=def_destination)

  # Create your Stream object with authentication
  stream = tweepy.Stream(auth, l)

  # Filter Twitter Streams to capture data by the keywords:
  stream.filter(track=l.keywords_list)


 

  
if __name__ == "__main__":
  main(sys.argv)