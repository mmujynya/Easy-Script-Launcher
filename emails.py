#!/usr/bin/env python3

import email.message
import mimetypes
import os.path
import smtplib
import ssl
import sys
from socket import gaierror




def generate_email(message,sender, recipient, subject, body, attachment_path):
  """Creates an email with an attachement."""
  # Basic Email formatting
  #message = email.message.EmailMessage()
  message["From"] = sender
  message["To"] = recipient
  message["Subject"] = subject
  message.set_content(body)

  # Process the attachment and add it to the email
  if attachment_path != 'None':
    attachment_filename = os.path.basename(attachment_path)
    mime_type, _ = mimetypes.guess_type(attachment_path)
    mime_type, mime_subtype = mime_type.split('/', 1)

    with open(attachment_path, 'rb') as ap:
      message.add_attachment(ap.read(), maintype=mime_type,subtype=mime_subtype,filename=attachment_filename)

  return message

def send_email(message,port,mail_server,username,password):
  """Sends the message to the configured SMTP server."""

  try:
    # Send your message with credentials specified above
    context = ssl.create_default_context()
    with smtplib.SMTP_SSL(mail_server, port,context=context) as server:
      server.login(username, password)
      #server.sendmail(sender, receiver, message)
      server.send_message(message)

  except (gaierror, ConnectionRefusedError):
    # tell the script to report if your message was sent or which errors need to be fixed
    print('Failed to connect to the server. Bad connection settings?')
  except smtplib.SMTPServerDisconnected:
    print('Failed to connect to the server. Wrong user/password?')
  except smtplib.SMTPException as e:
    print('SMTP error occurred: ' + str(e))
  else:
    print('Sent')




def main(argv):
  """ Sends an email with or without an attachment.
  Parameters=mail_server=smtp.gmail.com|port=465|username=someone@gmail.com|password=getMeFromGmail|sender=someone@gmail.com|recipient=someone@gmail.com|subject=Automated Task Notification|body=Nothing|attachment_path=hello.txt"""

  #Default Values
  attachment_path = r'C:\dev\ESL\hello.txt'
  mail_server = 'smtp.gmail.com'
  port = 465
  username = # fill this
  password = #get this from gmail if using 2 factors identifications
  sender = # fill this 
  recipient=''
  subject = 'Automated Task Notification'
  body =''

  # Parse all arguments except the first argument (which is the script filename)
  for item in argv[1:]:
    apos = item.find('=')
    avalue = item[apos+1:]

    if 'attachment_path=' in item:
      attachment_path  = avalue      
    if 'mail_server=' in item:
      mail_server = avalue  
    if 'port=' in item:
      port = int(avalue)
    if 'username=' in item:
      username = avalue 
    if 'password=' in item:
      password = avalue 
    if 'sender=' in item:
      sender = avalue 
    if 'recipient=' in item:
      recipient = avalue 
      print(recipient)
    if 'subject=' in item:
      subject = avalue 
    if 'body=' in item:
      body = avalue 

  #recipient=input()
  print('Email will be sent to: '+recipient)

  message = email.message.EmailMessage()
  generate_email(message,sender, recipient, subject, body, attachment_path)
  send_email(message,port,mail_server,username,password)

if __name__ == "__main__":
  main(sys.argv)
